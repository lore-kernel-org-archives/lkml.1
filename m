Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXHATIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXHATIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXHATH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:07:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:5570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXHATH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IJXnRMnOFkb0zJHQPcBNO6UC01Tc06BlW2NwK6pS+fB4G5CatfI/hsW/WfXrOcNMXj/9eVd7rTQfCFhqvXYk+njzuqanQgAhyqNtBSQyVYrqKfYmnWFpxU3UPjmOkiTwL6J13P07ihZq1Y//X15JTGsrR5blLWIrACdi/0861pM=
Date: Wed, 1 Aug 2007 23:07:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] update .gitignore
Message-ID: <20070801190753.GB5763@martell.zuzino.mipt.ru>
References: <20070801131051.GO3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801131051.GO3972@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 03:10:51PM +0200, Adrian Bunk wrote:
> --- linux-2.6.23-rc1-mm2/.gitignore.old
> +++ linux-2.6.23-rc1-mm2/.gitignore
> @@ -14,18 +14,25 @@
>  *.so
>  *.mod.c
>  *.i
> +!include/asm-*/*.i

I think these should be renamed to .S and let .i alone for preprocessed
stuff.

> +# .gitignore files
> +!.gitignore
> +
>  #
>  # Top-level generic files
>  #
>  tags
>  TAGS
>  vmlinux*
> -!vmlinux.lds.S
> +!vmlinux*.lds*
> +!vmlinux*.scr
>  System.map
>  Module.symvers
> +!.mailmap
> +!.mm

