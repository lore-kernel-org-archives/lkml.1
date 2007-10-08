Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXJHWRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXJHWRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXJHWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:17:23 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51917 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXJHWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:17:23 -0400
Message-ID: <470AAC22.8070900@aitel.hist.no>
Date: Tue, 09 Oct 2007 00:16:02 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc9 compile error drivers/video/fbmon.c
References: <470AA886.4070309@aitel.hist.no> <20071008221208.GQ16424@stusta.de>
In-Reply-To: <20071008221208.GQ16424@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Oct 09, 2007 at 12:00:38AM +0200, Helge Hafting wrote:
>   
>>  CC      drivers/video/fbmon.o
>> drivers/video/fbmon.c: In function ‘fb_parse_edid’:
>> drivers/video/fbmon.c:867: error: expected ‘=’, ‘,’, ‘;’, 
>> ‘asm’ or ‘__attrib
>> _’ before ‘*’ token
>> drivers/video/fbmon.c:867: error: ‘block’ undeclared (first use in this 
>> func
>> )
>>
>> This line reads:
>>    unsigned char$*block;
>>
>> Source error, or is my tree simply corrupt?
>>     
>
> The $ is a space character in my copy of the tree, so it seems to be a 
> corrupted tree with a bit error on your side ($ and the space character 
> differ by only one bit).
>   
I downloaded a new tree.
That file has quite a few single-bit errors in my old tree.
Mostly of the +16 variety.
Seems I have to look for bad memory :-( :-( :-(

Helge Hafting
