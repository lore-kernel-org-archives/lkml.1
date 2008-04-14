Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbYDNRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbYDNRy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbYDNRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:54:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42947 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761545AbYDNRy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:54:28 -0400
Date: Mon, 14 Apr 2008 19:54:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: hskinnemoen@atmel.com, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] avr32 mustn't select HAVE_IDE
Message-ID: <20080414175457.GB15028@uranus.ravnborg.org>
References: <20080414141650.GD6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414141650.GD6695@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 05:16:50PM +0300, Adrian Bunk wrote:
> There's a libata based PATA driver for avr32, but no support for 
> drivers/ide/ on avr32.
> 
> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/ide/ide-cd.o
> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/ide-cd.c:37:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:209:21: error: asm/ide.h: No such file or directory
> make[3]: *** [drivers/ide/ide-cd.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Obviously correct.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
