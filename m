Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbYETA3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbYETA3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYETA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:28:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbYETA2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:28:55 -0400
Date: Mon, 19 May 2008 17:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anas Nashif <nashif@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-Id: <20080519172821.023fb28f.akpm@linux-foundation.org>
In-Reply-To: <4832174A.20905@linux.intel.com>
References: <4832174A.20905@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 20:11:54 -0400
Anas Nashif <nashif@linux.intel.com> wrote:

> We have addressed more issues raised on lkml after initial submission,
> especially the legacy device support issue which was removed in this
> patch.
> 
> The Intel Management Engine Interface (aka HECI: Host Embedded
> Controller Interface ) enables communication between the host OS and
> the Management Engine firmware. MEI is bi-directional, and either the
> host or Intel AMT firmware can initiate transactions.
> 
> The core hardware architecture of Intel Active Management Technology
> (Intel AMT) is resident in firmware. The micro-controller within the
> chipset's graphics and memory controller (GMCH) hub houses the
> Management Engine (ME) firmware, which implements various services
> on behalf of management applications.
> 
> Some of the ME subsystems that can be access via MEI driver:
> 
> - Intel(R) Quiet System Technology (QST) is implemented as a firmware
> subsystem  that  runs in the ME.  Programs that wish to expose the
> health monitoring and fan speed control capabilities of Intel(R) QST
> will need to use the MEI driver to communicate with the ME sub-system.
> - ASF is the "Alert Standard Format" which is an DMTF manageability
> standard. It is implemented in the PC's hardware and firmware, and is
> managed from a remote console.
> 
> Most recent Intel desktop chipsets have one or more of the above ME
> services. The MEI driver will make it possible to support the above
> features on Linux and provides applications access to the ME and it's
> features.

What a lot of code.

It'd be nice if the changelog were to describe the proposed and
all-important kernel<->userspace interface, please.  From a five-second
peek it looks like a miscdev with ioctls?  Ah, and there's read and
write too.

What is the payload for those system calls, and the meanings of their
return values, etc, etc?

Does it make sense for this driver to be available on all
architectures?
