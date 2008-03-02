Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbYCBXRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbYCBXRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYCBXRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:17:40 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:51056 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYCBXRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GnXTI5FUhobDj9naqIvHl3N9FM9MHDJkFz8TLW+cOlcP60pQVU4rdXD8tH1fy5nsdLOu2DYccuITqDY+I3oQtOydNOV1xtrTSTBHSmrRXs1zV3GZQ0Y68u1ciPcJmkncKoDffvUlxhqjcOSB4gnIrz6S8KkihU4vYxkNnSVCqyM=
Message-ID: <9a8748490803021517o6017c7d8g36e1ffc509548080@mail.gmail.com>
Date: Mon, 3 Mar 2008 00:17:37 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Matt Reuther" <mreuther@umich.edu>
Subject: Re: 2.6.24.3 Error During Compile
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200803021303.50181.mreuther@umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803021303.50181.mreuther@umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2008, Matt Reuther <mreuther@umich.edu> wrote:
> I get the following error when I compile a vanilla 2.6.24.3 kernel:
>
>   UNIFDEF include/linux/hayesesp.h
>   UNIFDEF include/linux/hdlc.h
>   UNIFDEF include/linux/hdlcdrv.h
>   UNIFDEF include/linux/hdreg.h
>   UNIFDEF include/linux/hiddev.h
>   UNIFDEF include/linux/hpet.h
>   UNIFDEF include/linux/i2c.h
>   UNIFDEF include/linux/i2o-dev.h
>   UNIFDEF include/linux/icmp.h
>   UNIFDEF include/linux/icmpv6.h
>   UNIFDEF include/linux/if_addr.h
>  make[3]: *** No rule to make target
>  `/usr/local/src/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by
>  `/usr/local/src/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
>  make[2]: *** [linux] Error 2
>  make[1]: *** [headers_install] Error 2
>  make: *** [vmlinux] Error 2
>
>  My .config is attached. I carried over my .config from 2.6.23.12, and
>  ran 'make menuconfig' on it to update the options.
>
"make oldconfig" is usually what you want to use to carry over a
previous .config ... not that it will make any difference here, just
thought I'd mention it.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
