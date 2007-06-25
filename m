Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbXFYUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbXFYUcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXFYUc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:32:26 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:36831 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXFYUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:32:25 -0400
Message-ID: <46802649.9000403@opensound.com>
Date: Mon, 25 Jun 2007 23:32:09 +0300
From: Hannu Savolainen <hannu@opensound.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <Pine.LNX.4.64.0706242126200.11964@fbirervta.pbzchgretzou.qr> <Pine.BSO.4.63.0706251153060.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706251153060.25800@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko kirjoitti:
> On Sun, 24 Jun 2007, Jan Engelhardt wrote:
>
>>
>> On Jun 24 2007 21:24, Tomasz K³oczko wrote:
>>> Try to answer on question "ALSA or OSS ?" using *only* technical 
>>> arguments.
>>
>> Ok: The OSS cs46xx driver did not support the rear 2 channels.
The cs46xx OSS driver in the kernel is not our work. This discussion is 
about _our_ OSS 4.0 so the above is not a valid argument.
> Yes it is true .. OSS (Hannu tree) dos not provide rear 2 channels in
> cs46xx driver because .. in this OSS tree there is no cs46xx driver :>
The driver for cs46xx/cs4280 devices in OSS 4.0 is called cs4280.c. It's 
based on the same sample sources from Crystal than the kernel cs46xx 
one. It doesn't support the rear channels any better which could be an 
argument. However OSS is now an open source community project so anybody 
has freedom to fix this problem.

Best regards,

Hannu
