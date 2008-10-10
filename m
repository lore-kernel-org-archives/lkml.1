Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYJJEUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYJJEUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYJJEUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:20:44 -0400
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:52209
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJJEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:20:44 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 00:20:44 EDT
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the
 input subsystem
From: Jarod Wilson <jarod@wilsonet.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Jon Smirl <jonsmirl@gmail.com>, lirc-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081009120333.GA1623@ucw.cz>
References: <20081006194032.15992.8393.stgit@terra>
	 <20081009120333.GA1623@ucw.cz>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 00:11:39 -0400
Message-Id: <1223611899.13345.86.camel@xavier.wilsonet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 (2.24.0-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 14:03 +0200, Pavel Machek wrote:
> Hi!
> 
> >  What should the IR API look like?  How are IR events mapped into
> > keyboard events? Should they be mapped? Map them in the kernel or in
> > user space? The maps are tiny, less than 1K per remote.  Sysfs can
> > be used to load maps into the kernel driver. Make maps only for the
> > common buttons and don't map unusual ones?
> 
> Map them in kernel, in analogy with normal keyboards.

My thought was to basically follow what the ati_remote{,2} driver does.

> > How should multiple remotes be handled? Split them out into
> > individual input devices, or group them onto a single IR device? I
> > can implement either.
> 
> Individual input devices, I'd say... so that app can only listen for
> 'its' remote.

I don't quite get it. How can we tell there are multiple remotes to set
up multiple input devices when the system comes up? All we can know
about at driver init time is the receiver(s), no? Or would this be keyed
off a config file? Or ______ ?


-- 
Jarod Wilson
jarod@wilsonet.com

