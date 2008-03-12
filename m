Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYCLCIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYCLCIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYCLCH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:07:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51873 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYCLCH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:07:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	<20080311211004.GA30164@redhat.com> <200803112318.28120.rjw@sisk.pl>
Date: Tue, 11 Mar 2008 20:02:55 -0600
In-Reply-To: <200803112318.28120.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 11 Mar 2008 23:18:27 +0100")
Message-ID: <m1ejagzokw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Well, what can I say?
>
> I haven't been a big fan of doing hibernation this way since the very beginning
> and I still have the same reservations.  Namely, my opinion is that the
> hibernation-related problems we have are not just solvable this way.  For one
> example, in order to stop using the freezer for suspend/hibernation we first
> need to revamp the suspending/resuming of devices (uder way) and the
> kexec-based approach doesn't help us here.  I wouldn't like to start another
> discussion about it though.

Agreed.  At best all this does is moving the policy on how to save the kernel
image from the kernel itself out to user space, and it not a cure all.

> That said, I can imagine some applications of the $subject functionality
> not directly related to hibernation.  For example, one can use it for kernel
> debgging (jump to a new kernel, change something in the old kernel's
> data, jump back and see what happens etc.).  Also, in principle it may be used
> for such things as live migration of VMs.

Also such things as calling BIOS services or EFI services on x86_64.  Where
vm86 is not useful.

So in principle I think a kexec with return is a logical extension to
the current kexec functionality.  

That said it looks like next month before I will have time to do a reasonable
job of reviewing the current patches.  

Eric
