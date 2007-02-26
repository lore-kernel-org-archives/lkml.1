Return-Path: <linux-kernel-owner+w=401wt.eu-S1030199AbXBZNBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbXBZNBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030205AbXBZNBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:01:36 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:20689 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199AbXBZNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:01:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JoHcAxsHSk7GWbYCVU6NHtsL0Sh6f64b/t58sI2nxa2kfWqkX5FaRao3xRLGt/rZsJ+2lcF8q5UmAQLT6o8jIS5CVL2JjEYaF6aOj9r26hQVNC8r1EabnaLAUXNEzKgz1QkckHOpU87g2EqJWgGBOfXGxPt3m+Zz5xktjGkwC9U=
Message-ID: <6bffcb0e0702260501q214c3ac8xedee578e4e29a5be@mail.gmail.com>
Date: Mon, 26 Feb 2007 14:01:33 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1172397209.25076.365.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
	 <1172088044.25076.125.camel@localhost.localdomain>
	 <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com>
	 <20070223060802.GA8562@elte.hu>
	 <6bffcb0e0702241445v562be44y5ddac6d6abdb5131@mail.gmail.com>
	 <1172397209.25076.365.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Michal,
>
> On Sat, 2007-02-24 at 23:45 +0100, Michal Piotrowski wrote:
> > Here is a dmesg after over 25 hours of uptime
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc1/git-dmesg3
> > nothing new.
>
> can you please turn off CONFIG_SCHED_SMT ? It seems all reports have one
> thing in common:
>
> CPU == P4 and CONFIG_SCHED_SMT turned on.
>
>         tglx
>
>
>

Ok, I think that this is a SMT scheduler problem.

System works fine for fifteen hours.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
