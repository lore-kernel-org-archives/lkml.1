Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbYD1SGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbYD1SGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934576AbYD1SGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:06:42 -0400
Received: from minx.mdc-dayton.com ([70.62.41.4]:48627 "EHLO daetwyler-rd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934525AbYD1SGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:06:41 -0400
From: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
To: "'Miguel Ojeda'" <miguel.ojeda.sandonis@gmail.com>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Kathy Frazier'" <kfrazier@daetwyler-rd.com>,
       <linux-kernel@vger.kernel.org>
References: <009501c89e28$3d7530f0$b85f92d0$@com>	 <20080414133937.7080d30d@core> <006f01c8a4a7$82e37ea0$88aa7be0$@com>	 <20080425181219.61e29b1f@core> <ca2dc2820804251118j625abb76j100d165aee18a7c8@mail.gmail.com>
In-Reply-To: <ca2dc2820804251118j625abb76j100d165aee18a7c8@mail.gmail.com>
Subject: RE: Talking to parallel port in 2.6 kernel without using parport
Date: Mon, 28 Apr 2008 14:06:20 -0400
Message-ID: <004301c8a95a$906666c0$b1333440$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcinAOtTwdUwR5x4Q6C4ejvsqYAiQQCWLj3w
Content-Language: en-us
X-MyHeader: SpamAssassin Check skipped due to Authenication or Internal MDC-Dayton Address
X-MyHeader: Clam AV Check skipped due to Authenication or Internal MDC-Dayton Address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel,

Thanks for your response!  I took a look at ks0108.c.  You are right:  very
straightforward and a good reference.  I had added some other things based
on what I saw in /drivers/char/ppdev.c, lp.c and tipar.c.  After reviewing
yours, I am realizing I really don't need some of that, so I can simplify
mine.

My biggest problem was that lp was loaded.  When I remove that, my call to
parport_register_device returns success! 

Thanks for your help!

Regards,
Kathy 



-----Original Message-----
From: Miguel Ojeda [mailto:miguel.ojeda.sandonis@gmail.com] 
Sent: Friday, April 25, 2008 2:18 PM
To: Alan Cox
Cc: Kathy Frazier; linux-kernel@vger.kernel.org
Subject: Re: Talking to parallel port in 2.6 kernel without using parport

>  > Can you tell me what I am missing?  Where can I get the actual 
> source code  > that goes with this version to further unravel this?

About two years ago (~2.6.18) I wrote one driver that needed exclusive
access to the parallel port and, like this time, Alan Cox guided me (thank
you Alan!). If you want, you can check the code at
drivers/auxdisplay/ks0108.c. I tested it as of 2.6.25 and worked fine, so it
could be a good reference for you. In addition, the code is pretty
straightforward!

>
>  To be honest this area of the kernel hasn't changed much over recent  
> times. Let me know if you can't figure out what is going on.
>

Right, I haven't had to change the code since 2.6.18.

--
Miguel Ojeda

