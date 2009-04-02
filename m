Return-Path: <linux-kernel-owner+w=401wt.eu-S1765703AbZDBK4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765703AbZDBK4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZDBK4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:56:43 -0400
Received: from smtp.movial.fi ([62.236.91.34]:57685 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZDBK4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:56:43 -0400
Message-ID: <49D499E7.9020603@movial.com>
Date: Thu, 02 Apr 2009 13:56:39 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] de: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>
References: <Pine.LNX.4.64.0903292229400.23398@anakin> <200903302229.31846.bzolnier@gmail.com>
In-Reply-To: <200903302229.31846.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Sunday 29 March 2009, Geert Uytterhoeven wrote:
>> On m68k:
>> | drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
>> | drivers/ide/ide-atapi.c:87: error: implicit declaration of function 'sg_page'
>> | drivers/ide/ide-atapi.c:87: warning: passing argument 1 of 'PageHighMem' makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:91: warning: passing argument 1 of 'kmap_atomic' makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:96: error: implicit declaration of function 'sg_virt'
>> | drivers/ide/ide-atapi.c:96: warning: assignment makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:107: error: implicit declaration of function 'sg_next'
>> | drivers/ide/ide-atapi.c:107: warning: assignment makes pointer from integer without a cast
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> thanks, applied
> 
> [ Dmitri, sorry but m68k was faster than MIPS this time ;) ]

That's OK for me as long as Malta builds again :)

Dmitri
