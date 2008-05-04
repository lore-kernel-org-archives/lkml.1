Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYEDPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYEDPW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYEDPWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:22:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:54795 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751379AbYEDPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:22:19 -0400
X-Authenticated: #310364
X-Provags-ID: V01U2FsdGVkX1/M3ltzXJ/M4vWBTjkfqACYiVHCOSAxNl6roqRcb6
	EFfnljOdmM4Lo1
Message-ID: <01ae01c8adfa$a36f51b0$0201a8c0@zeug>
From: "Sebastian Herbszt" <herbszt@gmx.de>
To: <hadi@cyberus.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       <jbeulich@novell.com>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl> <481CC5CD.8060205@zytor.com> <Pine.LNX.4.55.0805032209480.20206@c <1209851170.6972.64.camel@localhost> <004701c8ade8$266832c0$0201a8c0@zeug> <1209913612.6972.89.camel@localhost>
Subject: Re: i387/FPU init issues...
Date: Sun, 4 May 2008 17:21:05 +0200
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

>> this is the same result i get with qemu 0.8.2. 
> 
> Thanks for validating. 
> I am embarassed to say I am still running version 0.7.0 - problem is i
> have patched it semi-substantially to add features which i didnt get
> much luck in pushing in; so i cant upgrade overnight.
> 
>> With version 0.9.0 and
>> later it is:
> 
> Ok, maybe it is time to invest time to forward port my patches. I dont
> see anything in the release notes between 0.8.2 and 0.9.0 which says
> this problem was known and fixed in some specific version. Any pointers?

>From http://fabrice.bellard.free.fr/qemu/changelog.html
version 0.9.0:
...
- several x86 and x86_64 emulation fixes

Revision 2145 introduced "multi byte nop support".
See http://svn.savannah.nongnu.org/viewvc/trunk/target-i386/translate.c

> Thanks again - you saved me a lot of time.
> 
> cheers,
> jamal

- Sebastian

