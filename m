Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXINR0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXINR0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXINR0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:26:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbXINR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:26:41 -0400
Date: Fri, 14 Sep 2007 19:26:30 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Andreas Schwab <schwab@suse.de>
cc: 7eggert@gmx.de, Brent Casavant <bcasavan@sgi.com>,
       Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <jek5qta5d0.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.58.0709141923001.2235@be1.lrz>
References: <92Haf-7z7-5@gated-at.bofh.it> <92TO5-246-1@gated-at.bofh.it>
 <92Zqu-2ur-1@gated-at.bofh.it> <E1IW8R4-0000ko-2z@be1.lrz> <jek5qta5d0.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/6pyd+NjDftgYwVBBa++M+i1pB2IKwOTYhMUk
 XmpzMPyMsHRaRlRYR0CE0E4L2py+k5QJ6+/z3UlIU+BMPeoVdT
 DcqUc28DrDFi0ommMwuow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Andreas Schwab wrote:
> Bodo Eggert <7eggert@gmx.de> writes:

> > ~/tmp > cp /bin/sleep .
> > ~/tmp > chmod u+s sleep
> > ~/tmp > ./sleep 2147483647 &
> > [1] 2823
> > ~/tmp > strace -p 2823
> > Process 2823 attached - interrupt to quit
> > setup(
> 
> You didn't change the owner, so this is not a setuid execution.

I expected that, but I wanted to be sure before telling bull****.
Besides that, if the suid program was owned by the suid-to user,
that user could modify the binary in order to prepare a future attack.
-- 
Top 100 things you don't want the sysadmin to say:
16. find /usr2 -name nethack -exec rm -f {};
