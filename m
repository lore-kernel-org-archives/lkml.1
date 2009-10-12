Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbZJLQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbZJLQCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZJLQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:02:21 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42174 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbZJLQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QdvM8cpYTQOCiK7Elg388ej8g6kc2lSjI5Obpw9bQw/CDEVYsgb8+YRMbmHehPsCDg
         I5jDiVQijObbZqPvl9C/A3LwJCAlKt32RoLfWWEIsX2ihAWZtR+zEtcC6MkR6f+65nWK
         UX/oamVBNOg0fIA4GrgL5r38XPA4phzlxLq2A=
Date: Tue, 13 Oct 2009 00:05:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.2 broke UML 64-bit build (2.6.31 was fine)
Message-ID: <20091012160548.GA3961@hack>
References: <4AD34542.7050500@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD34542.7050500@nagafix.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:03:30PM +0700, Antoine Martin wrote:
>tar -jxf linux-2.6.31.2.tar.bz2
>cd linux-2.6.31.2
>cp ../.config ./
>make ARCH=um
>[...]
>  MODPOST vmlinux.o
>  GEN     .version
>  CHK     include/linux/compile.h
>  UPD     include/linux/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
>/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:1:
>ignoring invalid character `#' in expression
>/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:1:
>syntax error
>collect2: ld returned 1 exit status
>  KSYM    .tmp_kallsyms1.S
>nm: '.tmp_vmlinux1': No such file
>No valid symbol.
>make: *** [.tmp_kallsyms1.S] Error 1


Hmm, this is a known problem:
https://lists.linux-foundation.org/pipermail/bugme-new/2009-May/021900.html

>
>Sorry, not had time to bisect it.
>Tested with gcc 4.1.2 and gcc 4.3.2
>Use this config if yours does not exhibit the problem:
>http://uml.devloop.org.uk/kernels/kernel64-2.6.31.config

No problem. Thanks for your report!

I will take care of this tomorrow, it's mid-night here already. :-)


-- 
Live like a child, think like the god.
 
