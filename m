Return-Path: <linux-kernel-owner+w=401wt.eu-S1030554AbXBUH0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554AbXBUH0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030561AbXBUH0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:26:11 -0500
Received: from tag.witbe.net ([81.88.96.48]:36699 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030554AbXBUH0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:26:09 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Marcus Haebler'" <haebler@gmail.com>, "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Pablo Sebastian Greco'" <lkml@fliagreco.com.ar>,
       <linux-kernel@vger.kernel.org>
Subject: RE: SATA problems
Date: Wed, 21 Feb 2007 08:25:52 +0100
Organization: AS2917.net
Message-ID: <012f01c75589$87d740e0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <d72aa1340702202224i209fb131pb0f9c2c9cc547e6d@mail.gmail.com>
Thread-Index: AcdVgQgyNDE1C0zHRYWksEaNxmgOswACDYrQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

Could you give more details ? I'm stucked with a boot problem on a 
Asus P5W that also includes a Jmicron behind a Sata port on ICH8, and
the kernel boot goes timeout when probing it... I've been trying various
kernels,
including some patches from Tejun (Thanks !), but no luck to date...

Mind sharing your .config so that I can check if I missed something obvious ?

Regards,
Paul

Paul Rolland, rol(at)as2917.net
ex-AS2917 Network administrator and Peering Coordinator

--

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
  

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Marcus Haebler
> Sent: Wednesday, February 21, 2007 7:24 AM
> To: Tejun Heo
> Cc: Pablo Sebastian Greco; linux-kernel@vger.kernel.org
> Subject: Re: SATA problems
> 
> Tejun,
> 
> I checked out the kernel 2.6.19 to 2.6.20 Changelog. Seems like you
> fixed a problem with the JMB363. The Asus P5B-Deluxe I am using has a
> JMB363 - besides an Intel ICH8R - with the SATA ports set to AHCI as
> well. Looks like that might have been the source of the problem in
> 2.6.19.
> 
> Thanks,
> 
> Marcus
> 
> On 2/21/07, Marcus Haebler <haebler@gmail.com> wrote:
> > Tejun,
> >
> > thanks. In preparation of your patch I installed a vanilla 2.6.20.1
> > kernel on my FC6
> > system. Amazingly the problem went away with the vanilla(!) 
> kernel and NCQ
> > is enabled at boot time (queue_depth is 31). I guess I should have
> > tried that kernel
> > earlier.
> >
> > The patches you sent earlier apply w/o problems against the 2.6.20.1
> > vanilla kernel
> > which is expected. I will test drive those patches tomorrow.
> >
> > BTW thanks for saving me the 'cat' on the 3 patches. ;)
> >
> > Thanks,
> >
> > Marcus
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

