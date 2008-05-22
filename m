Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbYEWHKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbYEWHKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbYEWHJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:09:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3207 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936022AbYEWHJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:09:54 -0400
Date: Thu, 22 May 2008 18:51:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080522165156.GA7431@ucw.cz>
References: <4832174A.20905@linux.intel.com> <20080519172821.023fb28f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519172821.023fb28f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We have addressed more issues raised on lkml after initial submission,
> > especially the legacy device support issue which was removed in this
> > patch.
> > 
> > The Intel Management Engine Interface (aka HECI: Host Embedded
> > Controller Interface ) enables communication between the host OS and
> > the Management Engine firmware. MEI is bi-directional, and either the
> > host or Intel AMT firmware can initiate transactions.
> > 
> > The core hardware architecture of Intel Active Management Technology
> > (Intel AMT) is resident in firmware. The micro-controller within the
> > chipset's graphics and memory controller (GMCH) hub houses the
> > Management Engine (ME) firmware, which implements various services
> > on behalf of management applications.
> > 
> > Some of the ME subsystems that can be access via MEI driver:
> > 
> > - Intel(R) Quiet System Technology (QST) is implemented as a firmware
> > subsystem  that  runs in the ME.  Programs that wish to expose the
> > health monitoring and fan speed control capabilities of Intel(R) QST
> > will need to use the MEI driver to communicate with the ME sub-system.
> > - ASF is the "Alert Standard Format" which is an DMTF manageability
> > standard. It is implemented in the PC's hardware and firmware, and is
> > managed from a remote console.
> > 
> > Most recent Intel desktop chipsets have one or more of the above ME
> > services. The MEI driver will make it possible to support the above
> > features on Linux and provides applications access to the ME and it's
> > features.
> 
> What a lot of code.
> 
> It'd be nice if the changelog were to describe the proposed and
> all-important kernel<->userspace interface, please.  From a five-second
> peek it looks like a miscdev with ioctls?  Ah, and there's read and
> write too.

Actuallly, we already have perfectly good interface for sensor-like
stuff -- in lm_sensors. Even acpi is moving in that direction...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
