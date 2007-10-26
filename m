Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbXJZAge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbXJZAge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXJZAgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:36:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:57319 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbXJZAgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:36:16 -0400
Message-ID: <472138D3.8090203@tmr.com>
Date: Thu, 25 Oct 2007 20:46:11 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: James Ausmus <james.ausmus@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
References: <b79f23070710241105n725e7a9dh78bb3747adc44437@mail.gmail.com>
In-Reply-To: <b79f23070710241105n725e7a9dh78bb3747adc44437@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Ausmus wrote:
> Since updating my laptop to 2.6.23, occasionally all of my free disk
> space on my root partition will just go away, with no files accounting
> for the space, with no odd messages in dmesg or my syslog. If I
> reboot, I immediately have the proper amount of free space again. Here
> is the output of a du -sx * on /, and the output of the df command
> when the problem is occuring, followed by the same info after a fresh
> reboot (literally just did the command in the failed state, then
> immediately rebooted and ran the same commands again) - any thoughts
> as to what might be happening?
> 
Clearly some process is still using a deleted file. However, if it 
doesn't happen with 2.6.22.x kernels, it would seem fall under the 
category of regression, in the "used to work" sense. Before going 
further you may want to be really sure that an older kernel doesn't do 
this, so no one wastes time on a non-problem.

Assuming the older kernel works fine, it's possible that some new 
behavior of the kernel as causing a process to misbehave, and step one 
is to use lsof and try to find the process. It's possible that "top" 
might be useful, although whatever is using the disk space may just be 
lurking.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
