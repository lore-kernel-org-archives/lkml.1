Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXGXXDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXGXXDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXGXXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:03:34 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:44368 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbXGXXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:03:33 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Wed, 25 Jul 2007 01:03:53 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <ca35ce500707110955t44d9b998r769c02df3e29e00a@mail.gmail.com> <ca35ce500707190324ncc7fbc0r4f05e00c74186dcc@mail.gmail.com>
In-Reply-To: <ca35ce500707190324ncc7fbc0r4f05e00c74186dcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707250103.54477.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikie,

> Do you have any news regarding my case of slow transfers via
> Speedtouch USB modem on linux ?

I found my old speedtouch modem and tested here.  I got 2.1 Mbaud
bulk downspeed, and 3 Mbaud isoc downspeed.  This last is half the
speed my line supports, so something is wrong [*].  Unfortunately
I'm not very motivated to try to find out what, because I don't
use this modem myself anymore.  It looks like someone needs to do
some more reverse engineering work on the windows driver.

Ciao,

Duncan.

[*] I got the same numbers the last time I tested isoc support,
but at that time 3 Mbaud was slightly less than the maximum speed
of my line, which explains why I didn't realize that there is a
problem.
