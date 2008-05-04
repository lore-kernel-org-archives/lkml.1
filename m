Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYEDNKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYEDNKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYEDNJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:09:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:44808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752052AbYEDNJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:09:58 -0400
X-Authenticated: #310364
X-Provags-ID: V01U2FsdGVkX19+YmQt0wR+JnXXgEguvVHBtYHm8jx81Tltaqdcir
	owgFXLK0DliNkP
Message-ID: <004701c8ade8$266832c0$0201a8c0@zeug>
From: "Sebastian Herbszt" <herbszt@gmx.de>
To: <hadi@cyberus.ca>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       <jbeulich@novell.com>
References: <1209810775.6972.37.camel@localhost>  <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>  <481CA40A.7040906@zytor.com>  <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>  <481CC5CD.8060205@zytor.com>  <Pine.LNX.4.55.0805032209480.20206@c <1209851170.6972.64.camel@localhost>
Subject: Re: i387/FPU init issues...
Date: Sun, 4 May 2008 15:08:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jamal,

> Sorry folks - had to run some errands. Wow, thanks for all the
> responses.
> 
> Yes, the posting i just did (as pointed in my first email) was on
> qemu (so was the /proc/cpuinfo). I moved to qemu because it was less
> painful to do the git bisecting on my laptop; i used the same .config.
> I should also note that qemu seems to have worked fine in the past.
> In any case I will try to rerun on the older hardware which i can access
> next week again. I am begining to doubt myself if it is the same issue;
> i know even there it was pointing to FPU.
> So is the correct fix then to go patch qemu then? I should point i am
> running a slightly older version of qemu that has a few patches (nothing
> to do with x86 emulation).
> 
> hpa, results from running on qemu (not the hardware) are:
> -----
> mambo:~# ./hpa
> Test 0: ok
> Test 1: ok
> Test 2: ok
> Test 3: err
> Test 4: err
> Test 5: err
> Test 6: err
> Test 7: err
> Test 8: err
> ----------------

this is the same result i get with qemu 0.8.2. With version 0.9.0 and
later it is:

debian:~# ./hpa
Test 0: ok
Test 1: ok
Test 2: ok
Test 3: ok
Test 4: ok
Test 5: ok
Test 6: ok
Test 7: ok
Test 8: ok

> cheers,
> jamal
 
-  Sebastian

