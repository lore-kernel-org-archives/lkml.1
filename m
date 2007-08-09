Return-Path: <linux-kernel-owner+w=401wt.eu-S935401AbXHIAT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401AbXHIAT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXHIATR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:19:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43074 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbXHIATQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:19:16 -0400
Date: Thu, 9 Aug 2007 01:19:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: J??rn Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 18/18] include/linux/Kbuild
Message-ID: <20070809001913.GA10044@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	J??rn Engel <joern@logfs.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	akpm@osdl.org, David Woodhouse <dwmw2@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
References: <20070808161234.GB15319@lazybastard.org> <20070808162447.GT15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808162447.GT15319@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 06:24:47PM +0200, J??rn Engel wrote:
> --- linux-2.6.21logfs/include/linux/Kbuild~logfs	2007-08-08 02:57:37.000000000 +0200
> +++ linux-2.6.21logfs/include/linux/Kbuild	2007-08-08 02:57:37.000000000 +0200
> @@ -101,6 +101,7 @@ header-y += jffs2.h
>  header-y += keyctl.h
>  header-y += limits.h
>  header-y += lock_dlm_plock.h
> +header-y += logfs.h

That file doesn't define any kind of user<->kernel interface and thus should
not be exported.

