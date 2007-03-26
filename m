Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbXCZPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbXCZPIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXCZPIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:08:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:37316 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXCZPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eITSg1QRSxJh1y6pxxdjefj4sGyymuzA0w7lAwOORFvbkjJt1HfkAc4DYPBD/H2SalAcZX1ItvV4Pg7vfS/y9COYNDyH+J0FRjT0OZ2VgjbHZUbZoUG5ec2oXTuHHYSZNR+SOf2xT7Eo8f2dJNCfNWQivxWyoj3m/cBnLE1Ok1c=
Message-ID: <6bffcb0e0703260807q37f27435ue5269a3611b0aae4@mail.gmail.com>
Date: Mon, 26 Mar 2007 17:07:57 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch] hrtimers debug patch
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <6bffcb0e0703260742m5fa8fa62td2a65490c1c4a50a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323021115.GA11147@wotan.suse.de>
	 <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
	 <20070323120148.GA27505@elte.hu> <4607BDD9.1010002@googlemail.com>
	 <6bffcb0e0703260720i37bbb956o3d20019fe4ac9879@mail.gmail.com>
	 <1174919635.4182.51.camel@chaos>
	 <6bffcb0e0703260742m5fa8fa62td2a65490c1c4a50a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 26/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 2007-03-26 at 16:20 +0200, Michal Piotrowski wrote:
> > > >
> > > > I've got a crash dump, I'll try to figure out what is causing it ;)
> > > >
> > >
> > > That might be useful
> > > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/
> >
> > Can you please upload a disassembly of hrtimer_interrupt() ?
>
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/dis_hrtimer_interrupt
>

I just noticed, that 'dis hrtimer_interrupt > dis_hrtimer_interrupt'
doesn't save the whole output.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/hrtimer_interrupt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
