Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZKZTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZKZTpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZKZTpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:45:41 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:46370 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbZKZTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:45:40 -0500
Message-ID: <4B0EDAF9.7080902@bluewatersys.com>
Date: Fri, 27 Nov 2009 08:46:01 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx
 CPUs
References: <200911261651.40928.bzolnier@gmail.com>
In-Reply-To: <200911261651.40928.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Based on the older IDE host driver by Joao Ramos and review comments
> for it from Sergei Shtylyov.  Not yet tested with the real hardware.

> 
> Sidenote:
> 
> I have neither the hardware nor much personal interest in adding support
> for it so I did it mainly cause:
> 
> - IDE host driver wasn't merged due to policy change and I hate seeing fair
>   amount of review work from me & Sergei going into waste. :)
> 
> - I was curious about some claims I've been hearing recently so I decided to
>   verify them in practice (porting the driver to libata was relatively easy
>   but unfortunately in the process it gained almost 50% in the LOC count..).
> 
> so if somebody would like to take over this patch feel free to do it.

Thanks for doing this. I'll see if I can dig out a hard-drive and give
this a test. I had some comments, but I will fix them up myself if I get
round to testing this.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
