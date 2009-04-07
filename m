Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZDGXYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZDGXYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZDGXYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:24:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:49089 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZDGXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=b24wlF4cja4oihwCsr7PFnWTgLj2xXUPc9nqED6c0Ynnbb5I0vjaIHOVg9NJ08ob9Z
         bfVfgNzQRAKbaKTMSDdeIkpzlhok+J9jGgdnnSQGj/ZjAQPUF1xUlSVjehXPSZfnzNBp
         q/PbzS0hgwzWUidkh0t16hoVELxbzevE6TPUY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git pull] IDE updates part 4
Date: Wed, 8 Apr 2009 01:26:58 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-10247-g8e2c4f2-dirty; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904080020.43175.bzolnier@gmail.com> <49DBD3EE.3010601@garzik.org> <200904080059.43698.bzolnier@gmail.com>
In-Reply-To: <200904080059.43698.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904080126.58613.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 00:59:43 Bartlomiej Zolnierkiewicz wrote:

[...]

> diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
> index 7b7cd76..4ed66d0 100644
> --- a/drivers/ide/ide.c
> +++ b/drivers/ide/ide.c
> @@ -178,11 +178,14 @@ EXPORT_SYMBOL_GPL(ide_pci_clk);
>  module_param_named(pci_clock, ide_pci_clk, int, 0);
>  MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
>  
> +/* needs block layer support */
> +#if 0
>  int ide_trim = 0;

This patch is crap and will break ide-disk build.

Linus, I'll revisit the pull request later...
