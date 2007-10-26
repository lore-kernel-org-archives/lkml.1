Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXJZTOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXJZTOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXJZTOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:14:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22958 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXJZTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MgJJ31lORY/5iWviuO38U/oA4ivum9m+HydJyb0aJURiW9VduSG0BjJaixi3+2VOpCz98VdrvGQADbu5doYL3+7F4bG/nXLPaJiOPLkvhFCsn77bIDZ32a4/imi5Cw1uRw5G2n4TXsrjSKiFIhf949PAsY1mcX47qd1F5Y0Ujz0=
Message-ID: <b79f23070710261214l302e44b1n1fbec88249084185@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:14:08 -0700
From: "James Ausmus" <james.ausmus@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <472138D3.8090203@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b79f23070710241105n725e7a9dh78bb3747adc44437@mail.gmail.com>
	 <472138D3.8090203@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Bill Davidsen <davidsen@tmr.com> wrote:
> James Ausmus wrote:
> > Since updating my laptop to 2.6.23, occasionally all of my free disk
> > space on my root partition will just go away, with no files accounting
> > for the space, with no odd messages in dmesg or my syslog. If I
> > reboot, I immediately have the proper amount of free space again. Here
> > is the output of a du -sx * on /, and the output of the df command
> > when the problem is occuring, followed by the same info after a fresh
> > reboot (literally just did the command in the failed state, then
> > immediately rebooted and ran the same commands again) - any thoughts
> > as to what might be happening?
> >
> Clearly some process is still using a deleted file. However, if it
> doesn't happen with 2.6.22.x kernels, it would seem fall under the
> category of regression, in the "used to work" sense. Before going
> further you may want to be really sure that an older kernel doesn't do
> this, so no one wastes time on a non-problem.
>
> Assuming the older kernel works fine, it's possible that some new
> behavior of the kernel as causing a process to misbehave, and step one
> is to use lsof and try to find the process. It's possible that "top"
> might be useful, although whatever is using the disk space may just be
> lurking.
>

OK, false alarm, this is definitely a userpsace (or a user... :)
problem - had a 12GB .xsession-errors file that I had deleted but was
still being held open - now I just have to determine why I have a 12GB
.xsession-errors file... :(

Thanks for the help all!

-James

> --
> Bill Davidsen <davidsen@tmr.com>
>    "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
>
