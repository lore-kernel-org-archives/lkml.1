Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbZANVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbZANVLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZANVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:11:47 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:62330 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZANVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jy+DfE/PoMup/93PLT7IKBLiq4UTW4g/R4LjPE6g2IZJTPSCsQB9cfjAOyAfuydZGZ
         jb0t3AKyY289/ZRKtXWD4br6B9O5TRMpZFUoFf9FFkf8v6Fu1OQyYHYYQuyb7zvAmGlC
         G5e741HgiyUgvYXzmMIN81vzH2jXU4vNkRGFY=
Date: Thu, 15 Jan 2009 00:11:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, jaswinderrajput@gmail.com
Subject: Re: [patch 1/5] x86: headers cleanup - boot.h
Message-ID: <20090114211142.GE8178@localhost>
References: <20090114203745.285473388@gmail.com> <496e4e23.1358560a.0b42.ffff8588@mx.google.com> <1231967080.5756.12.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231967080.5756.12.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Wed, Jan 14, 2009 at 01:04:40PM -0800]
| On Wed, 2009-01-14 at 23:37 +0300, Cyrill Gorcunov wrote:
| > -#if (defined CONFIG_KERNEL_BZIP2)
| > +#ifdef CONFIG_KERNEL_BZIP2
| >  #define BOOT_HEAP_SIZE             0x400000
| > -#else
| > +#else /* !CONFIG_KERNEL_BZIP2 */
| 
| Curious, I haven't seen the #else comments with the extra ! before,
| is that something that's coming into common use?
| 
| Harvey
| 

Actually I saw the both.

./arch/mips/include/asm/dec/prom.h:54:#else /* !CONFIG_64BIT */
./arch/mips/include/asm/dec/prom.h:58:#endif /* !CONFIG_64BIT */

		- Cyrill -
