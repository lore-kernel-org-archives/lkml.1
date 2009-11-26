Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZKZQnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZKZQnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZKZQnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:43:10 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:24722 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755851AbZKZQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:43:09 -0500
Message-ID: <4B0EB057.10301@ru.mvista.com>
Date: Thu, 26 Nov 2009 19:44:07 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911261640.39208.bzolnier@gmail.com> <4B0EA9FC.1000208@ru.mvista.com> <200911261729.46700.bzolnier@gmail.com>
In-Reply-To: <200911261729.46700.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>>>>>>MWDMA0 timings cannot be met with the PIIX based controller
>>>>>>>>programming interface.

>>>>>>>The efar documentation makes no reference to not being capable of MWDMA0,
>>>>>>>so where does this come from ? No MWDMA0 is an Intel erratum it appears.

>>>>>>No MWDMA0 support is a common issue on all 'PIIX-like' controllers.

>>>>>>In case of this chipset while the (preliminary) documentation claims MWDMA0
>>>>>>support on the 'FEATURES' page the later 'programming guide' part describes
>>>>>>only PIO0-4, SWDMA2, MWDMA1-2 and UDMA0-4 transfer modes as supported.

>>>>>Cool - I only have the original docs.

>>>>   Hm, me too... perhaps worth putting in Jeff's documentation archive?

>>>Me too?  I just have what 'The Good Uncle Google' has..

>>    Well, I've googled for it and was unable to find any valid links even to 
>>my preliminary version anymore. Perhaps I haven't looked hard enough...

> Maybe... ;)

> FWIW my file is called 38384_SMSC_SLC90E66.pdf

    Well, that brought me to some Chinese site with 07/10/2002 version 
(which I've already found minutes before that). But it still claims support 
for MWDMA0 under the features... ah, I need to look further down... no 
"programming guide" part, hm... but thanks anyway. :-)

> --
> Bartlomiej Zolnierkiewicz

WBR, Sergei
