Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbXLMCIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbXLMCIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 21:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLMCIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 21:08:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXLMCIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 21:08:36 -0500
Message-ID: <476093B6.7080306@zytor.com>
Date: Wed, 12 Dec 2007 18:06:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <Pine.LNX.4.64.0712130041590.32346@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712130041590.32346@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 12 2007 00:31, Rene Herman wrote:
>> Would some people on x86 (both 32 and 64) be kind enough to compile and run the
>> attached program? This is about testing how long I/O port access to port 0x80
>> takes. It measures in CPU cycles so CPU speed is crucial in reporting.
>>
> 
> Transmeta TM5800 CPU with nominal frequency 933 MHz, but it has a
> hardware(!) 'ondemand' governor over the range of frequencies that
> the user allowed scaling over, irrespective of the software governor.
> (That is, if the CPU can do 300,533 and 933 MHz, and setting the
> min/max to 300/533 will cause the hardware to 'ondemand' between 300
> and 533 only. And that even if 'performance' is set on the software
> side - so the only way to enforce 'performance' is to actually set
> min=933.)
> 

Actually it has two different ones (economy and performance), you can 
use the "longrun" utility to select which one.

Either way, all Transmeta processors have a fixed TSC, so there is no issue.

	-hpa
