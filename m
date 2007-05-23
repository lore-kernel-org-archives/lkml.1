Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXEXBY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXEXBY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760656AbXEXBYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:24:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:3072 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760766AbXEXBYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GQ68m1JgAoooEMaPvEObt0uQNTtg+bJlNtfNSvT9/uKoJCUflPDsIILp2Guksmd5YMQySkH5L+9X/UIiTcivlGKB2hunNiRJglMP8/ji/0+xeKZPkoOWmWXh3LIMV02FHoddu6BCOygw9b0+OaFz1kVYW9jfhqQC7eiOlAzyMXY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
Date: Thu, 24 May 2007 01:45:37 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070515201914.16944e04.akpm@linux-foundation.org> <20070516185552.GA4086@stusta.de>
In-Reply-To: <20070516185552.GA4086@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240145.38055.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 16 May 2007, Adrian Bunk wrote:
> On Tue, May 15, 2007 at 08:19:14PM -0700, Andrew Morton wrote:
> >...
> > - Added an i386 early-startup development tree, as git-newsetup.patch ("H. 
> >   Peter Anvin" <hpa@zytor.com>)
> >...
> > Changes since 2.6.21-mm2:
> >...
> >  git-newsetup.patch
> >...
> >  git trees
> >...
> 
> This breaks the compilation of the oldest of our IDE disk drivers:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `hd_init':
> hd.c:(.init.text+0x44a7d): undefined reference to `drive_info'
> hd.c:(.init.text+0x44a89): undefined reference to `drive_info'
> hd.c:(.init.text+0x44a95): undefined reference to `drive_info'
> hd.c:(.init.text+0x44aa1): undefined reference to `drive_info'
> hd.c:(.init.text+0x44aad): undefined reference to `drive_info'
> drivers/built-in.o:hd.c:(.init.text+0x44ab9): more undefined references to `drive_info' follow
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> Considering the fact that we have two more recent drivers with the same 
> functionality, it might be an option to simply remove this driver...

Care to send a patch?

Thanks,
Bart
