Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbXBSBAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbXBSBAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 20:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXBSBAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 20:00:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:29853 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXBSBAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 20:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rXmmIVVjs4OeOlJSOur8AwMgfKDPljy5e5oNuTNnZik+8iBzcHdXgDE6zWlWCM8IDPDOe2CUnBKYl69YnwGshTQF7vB1KdJadhqZMehzlvGDz/6sej7Qbxo0IXGmZom5FWmLqSl2zWCHsf9vXqNButYu9wOJrIB22n8MHbwf3IA=
Message-ID: <6bffcb0e0702181700x17d9a100v1e6cf4638464459d@mail.gmail.com>
Date: Mon, 19 Feb 2007 02:00:02 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alex Riesen" <fork0@users.sourceforge.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
Subject: Re: 2.6.20-git13 kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
In-Reply-To: <20070218172410.GA2421@steel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
	 <1171725257.30834.120.camel@localhost.localdomain>
	 <20070217164652.GA2579@steel.home>
	 <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
	 <1171788100.30834.169.camel@localhost.localdomain>
	 <20070218095037.GA3408@steel.home>
	 <1171802216.30834.172.camel@localhost.localdomain>
	 <20070218172410.GA2421@steel.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/07, Alex Riesen <fork0@users.sourceforge.net> wrote:
> Thomas Gleixner, Sun, Feb 18, 2007 13:36:56 +0100:
> > On Sun, 2007-02-18 at 10:50 +0100, Alex Riesen wrote:
> > > > The arch/i386/kernel/process.c part of the patch should apply to 2.6.20
> > > > as well. Can you check if the problem is there too ?
> > >
> > > It does not apply and does not look trivially hackable.
> > > The code for cpu_idle was introduced in 2ff2d3d7 "i386: add idle notifier".
> >
> > Here you go.
> >
>
> Ok, I confirm the message in vanilla v2.6.20
>

dmesg | grep Idle
Idle: local softirq pending: 0020

uname -a
Linux bitis-gabonica.linuxtestersgroup.org 2.6.20 #1 SMP PREEMPT Sun
Feb 18 15:20:27 CET 2007 i686 i686 i386 GNU/Linux

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
