Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXLLRGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXLLRGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXLLRFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:05:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbXLLRFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:05:53 -0500
Message-ID: <47601395.5040502@zytor.com>
Date: Wed, 12 Dec 2007 09:00:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <200712121753.54357.linux@rainbow-software.org>
In-Reply-To: <200712121753.54357.linux@rainbow-software.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> 
> Cyrix MII PR300 (225MHz), i430TX:    cycles: out 263, in 93
> Pentium MMX 166MHz @133MHz, VIA VPX: cycles: out 163, in 163
> Celeron 433MHz, i440BX:              cycles: out 620, in 305
> Celeron 1.3GHz, i440BX:              cycles: out 2114, in 849
> Celeron 1.7GHz (P4-based), i845:     cycles: out 2178, in 1651
> Pentium 4 3.2GHz, i925X:             cycles: out 2824, in 1899
> Xeon E5310 1.6GHz, Dell PE1950       cycles: out 2631, in 1606
> Xeon 3050 2.13GHz, Dell PE860        cycles: out 3367, in 1959
> 

So between 0.88 and 1.6 µs for the out case; 0.4 and 1.0 µs for the in case.

	-hpa

