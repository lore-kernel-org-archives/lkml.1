Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbXIPLAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbXIPLAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 07:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXIPLAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 07:00:11 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36342 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbXIPLAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 07:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RaNIP6/VBdxNWT3x8cpk+sSTysKIA6XAvMqD6w4s6699dJy5b2imbsoHs5a1gTMtphmiIBH7YgAZEvVvzjajtJLlZrMsnrWxZOtHboLuSeDZi3bZ1wk3G/Hub6qvFtupew2xK6/LGu4fQasACws2ie4H4iDbW0g2gx5SlKT8C8M=
Message-ID: <8b67d60709160400u7219e825v2b4eb7ac0d2f2193@mail.gmail.com>
Date: Sun, 16 Sep 2007 12:00:09 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Latest git won't compile
In-Reply-To: <8b67d60709151320h1f363b4cl57023627d8139680@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709151320h1f363b4cl57023627d8139680@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/2007, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> CC      drivers/char/tty_ioctl.o
> drivers/char/tty_ioctl.c: In function 'n_tty_ioctl':
> drivers/char/tty_ioctl.c:799: error: implicit declaration of function
> 'kernel_termios_to_user_termios_1'
> drivers/char/tty_ioctl.c:806: error: implicit declaration of function
> 'user_termios_to_kernel_termios_1'
> make[2]: *** [drivers/char/tty_ioctl.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
>

This morning's git does compile (SH4) and I see a fix went in...
