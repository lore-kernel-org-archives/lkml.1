Return-Path: <linux-kernel-owner+w=401wt.eu-S1750937AbXBXLKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbXBXLKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXBXLKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:10:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXBXLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:10:33 -0500
Date: Sat, 24 Feb 2007 03:10:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sacher Khoudari <Sacher.Khoudari@stud.uni-heidelberg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: isapnp: broken API
Message-Id: <20070224031000.e8439e5f.akpm@linux-foundation.org>
In-Reply-To: <20070223162505.rdtobeij48o40sow@wwwmail.urz.uni-heidelberg.de>
References: <20070223162505.rdtobeij48o40sow@wwwmail.urz.uni-heidelberg.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 16:25:05 +0100 Sacher Khoudari <Sacher.Khoudari@stud.uni-heidelberg.de> wrote:
> --- linux-2.6.20.1/drivers/pnp/isapnp/core.c.old	2007-02-23 16:20:46.000000000 +0100
> +++ linux-2.6.20.1/drivers/pnp/isapnp/core.c	2007-02-23 16:21:25.000000000 +0100
> @@ -943,9 +943,7 @@
>  EXPORT_SYMBOL(isapnp_present);
>  EXPORT_SYMBOL(isapnp_cfg_begin);
>  EXPORT_SYMBOL(isapnp_cfg_end);
> -#if 0
>  EXPORT_SYMBOL(isapnp_read_byte);
> -#endif
>  EXPORT_SYMBOL(isapnp_write_byte);

Yeah, that was a rather silly unexport.  I'll apply this, thanks.
