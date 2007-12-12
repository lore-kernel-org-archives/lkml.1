Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbXLLKgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbXLLKgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbXLLKgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:36:38 -0500
Received: from nn7.de ([85.214.94.156]:57024 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbXLLKgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:36:37 -0500
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
From: Soeren Sonnenburg <kernel@nn7.de>
To: Shane <gnome42@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Dec 2007 11:36:32 +0100
Message-Id: <1197455794.8814.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 00:20 -0500, Shane wrote:
> In 2.6.24-rc5+, I hit this problem with videobuf_read_start
> not being exported. Patch attached, only compile tested.
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC [M]  drivers/media/video/videobuf-core.o
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   MODPOST 202 modules
> ERROR: "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

FWIW, I've seen the same thing and Shane's patch fixes things for me.

Soeren
