Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZEKWZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZEKWZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZEKWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:24:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:32870 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZEKWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MCTIitaScpVzQsYFUYwbONjsggGyBIFtOn9GF9v2p9lZUoA9ypJYSqJFNik8iCmZQ2
         m2VaMO4I3LgaggdnDKWWxUtewogPVjIq4Ut53meisg9IcbThz55SMCwcW8J3mmshP7Gu
         7Kh4kRS844kH0siOUxROoIhuCXb0CbtKIZeIU=
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <4A089E49.7080403@gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 15:18:54 -0700
Message-Id: <1242080334.1991.11.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 23:53 +0200, Jiri Slaby wrote:
> Adding some CCs.
> 
> On 05/11/2009 07:02 PM, Justin Mattock wrote:
> > I've been trying to diagnose an issue
> > with 2.6.30-rc4. At first thinking it
> > was not the kernel, but the network manager
> > (in my case I use wicd).
> > with 2.6.29-rc8 the system starts up,
> > connects no problem.
> > but as soon as I load 2.6.30-rc4
> > I get limited connection to none.
> > in dmesg I see:
> > 
> > [   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > [   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > 
> > The type of encryption used is just
> > a standard WEP key(no WPA).
> > 
> > has this been resolved already?
> > 
> > Also I'm noticing(but not that big of a deal)
> > if I set in sysctl.conf:
> > 
> > net.ipv4.conf.all.arp_ignore=8
> > net.ipv4.conf.wlan0.arp_ignore=8
> > net.ipv4.conf.wmaster0.arp_ignore=8
> > net.ipv4.conf.lo.arp_ignore=8
> > net.ipv4.conf.all.arp_announce=2
> > net.ipv4.conf.wlan0.arp_announce=2
> > net.ipv4.conf.wmaster0.arp_announce=2
> > net.ipv4.conf.lo.arp_announce=2
> > 
> > watching a movie on hulu, about 15/20 minuets
> > into enjoyment, hulu craps out(starts re-buffering)
> > then re initializes after about 30 secs later.
> > but if I comment those out(set back to default)
> > hulu will run fine.
> > 
> 

Cool.
Another odd thing Ive experienced as well
with 2.6.29-rc8 is if my iphone is
connected to the router I'll have a hard time connecting
to anything until I disconnect the iphone
from the router.(my guess is the router is getting
old).

regards,

Justin P. Mattock

