Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYGZQwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYGZQwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYGZQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:52:28 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:62273 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752768AbYGZQw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:52:27 -0400
Date: Sat, 26 Jul 2008 18:48:08 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/video/atmel_lcdc.h must #include
 <linux/workqueue.h>
Message-ID: <20080726184808.5fa9e8c3@siona.local>
In-Reply-To: <20080725200348.GG19310@cs181140183.pp.htv.fi>
References: <20080725200348.GG19310@cs181140183.pp.htv.fi>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 23:03:48 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following compile error caused by
> commit d22579b837358cbef12ccca5adaf7e93ae09ab7a
> (atmel_lcdfb: FIFO underflow management):
> 
> <--  snip  -->
> 
> ...
>   CC      arch/avr32/boards/atstk1000/atstk1004.o
> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1004.c:21:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/video/atmel_lcdc.h:40: error: field 'task' has incomplete type
> make[2]: *** [arch/avr32/boards/atstk1000/atstk1004.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to the avr32 tree. Thanks a lot!

Haavard
