Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXGPOQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXGPOQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765348AbXGPOPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:15:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:64078 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765224AbXGPOPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JpCshz8Ef5b5WhVemmOp0tJn8r/koY/og8s81SykR9wYSRrItL8JHH2f9f94cADAEbp11rgUNtt0AjrBqSXg/NpoP1cLBXD4ieGQGhfndKIJyzqYEk04mKQOlYwEr+KlOy1FmeRxTk53wm04klm8AOMdGxnuVEP5n9vA5KHHRsI=
Message-ID: <a4e6962a0707160715ya0724f4lc61ce99f8132a76d@mail.gmail.com>
Date: Mon, 16 Jul 2007 09:15:35 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "=?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?=" <ariveira@gmail.com>
Subject: Re: [9Pfs] Compilation error
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070716153440.54f06c12@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070716153440.54f06c12@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Alejandro Riveira Fernández <ariveira@gmail.com> wrote:
>
>  I get this in today's head 8f41958bdd577731f7411c9605cfaa9db6766809
>
> $ make O=../2.6.23
>   Using /home/alex/kernel/linux-2.6 as source for kernel
>   GEN     /home/alex/kernel/2.6.23/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    /home/alex/kernel/linux-2.6/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC [M]  fs/9p/v9fs.o
> /home/alex/kernel/linux-2.6/fs/9p/v9fs.c: En la función 'v9fs_parse_options':
> /home/alex/kernel/linux-2.6/fs/9p/v9fs.c:134: error: 'p9_debug_level' no se declaró aquí (primer uso en esta función)
> /home/alex/kernel/linux-2.6/fs/9p/v9fs.c:134: error: (Cada identificador no declarado solamente se reporta una vez
> /home/alex/kernel/linux-2.6/fs/9p/v9fs.c:134: error: ara cada funcion en la que aparece.)
> make[3]: *** [fs/9p/v9fs.o] Error 1
> make[2]: *** [fs/9p] Error 2
> make[1]: *** [fs] Error 2
> make: *** [_all] Error 2
>

Thanks, someone already submitted a patch, I'm merging and testing now.

         -eric
