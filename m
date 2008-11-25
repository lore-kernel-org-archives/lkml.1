Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYKYImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYKYImY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYKYImP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:42:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:4742 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKYImO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=aoBmNRneWqFkPWMdcoscuHCihlZDbgtonbHNEhS6oqVYBPslYhTYlJssb3EIS1GJrf
         p6RzdsujyQu539sSEkZGi6nQDcLULSqdufHnhTWhx+iCHS10CGl2FKY4EOezpJ7YarjT
         U10gtJ7E6cpBbgDmMJ8loDrq1c8EUq7CEQZME=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: Still some problems with the rt2x00 driver
Date: Tue, 25 Nov 2008 09:42:09 +0100
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080620175729.GA3151@ime.usp.br> <200808041526.08332.IvDoorn@gmail.com> <3977BB08-9149-41E4-B187-235F36204E4E@ime.usp.br>
In-Reply-To: <3977BB08-9149-41E4-B187-235F36204E4E@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811250942.09259.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> There are two strange things that I've noticed, though and that I  
> feel need to be fixed:

For both cases:
Is there anything in the log regading the drivers or mac80211?

Ivo

> 1 - the rt63 driver used by a PCMCIA card DWL-G630 model has, for  
> many kernels (from 2.6.24 and up to and including kernel 2.6.27, as  
> shipped by Ubuntu for ia32), shown a strange behavior: after  
> everything is working correctly, the network simply becomes  
> unavailable, with the gnome network monitor showing that the card has  
> no signal. If I issue the command "iwconfig ra0 ap any", for example,  
> the card starts working again.
> 
> (Actually, I put this on a cron job to be executed every minute, but  
> even then, there are time windows where the card is not working). I'm  
> not in front of the notebook (a very old Armada V300 that my parents  
> are using for production), so I don't know if the card looses  
> association with the Access Point or not. I can check that, if nobody  
> else reported this problem yet.
> 
> 2 - the rt2500usb driver that I use on a very old iBook G3 (powerpc)  
> also works fine and has a similar, but not identical behaviour: the  
> DWL-G122 USB stick that I have works fine once associated and when it  
> is transferring data. Once I leave the network unused for, say, 2  
> minutes, the connection with the AP is dropped. Here, also, issuing  
> "iwconfig wlan0 ap any" makes it work again.
> 
> Notice the difference in both cases: with the PCMCIA/ia32 case, no  
> matter if there is traffic on the network or not, the the connection  
> is interrupted. With the USB/powerpc case, if there is traffic, the  
> connection remains working fine.
> 
> > Note that I am not going to push it to 2.6.26 since I don't know if  
> > the
> > patch will cause problems in other parts of the driver.
> 
> There's no problem. I can compile vanilla kernels from kernel.org  
> without any problems.
> 
> 
> Thanks for your kind help, Rogério Brito.
> 


