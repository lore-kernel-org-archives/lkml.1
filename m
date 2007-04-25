Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXDYMgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXDYMgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXDYMgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:36:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35896 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbXDYMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:36:04 -0400
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
From: David Woodhouse <dwmw2@infradead.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
In-Reply-To: <1172690012.16062.138.camel@localhost.localdomain>
References: <1172690012.16062.138.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 13:35:57 +0100
Message-Id: <1177504557.2755.216.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> Add LZO1X compression/decompression support to jffs2.
> 
> LZO's interface doesn't entirely match that required by jffs2 so a 
> buffer and memcpy is unavoidable.
> 
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

> Index: linux/fs/jffs2/compr_lzo.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux/fs/jffs2/compr_lzo.c	2007-02-28 18:12:31.000000000 +0000
> @@ -0,0 +1,120 @@
> +/*
> + * JFFS2 LZO Compression Interface
> + *
> + * Copyright (C) 2007 Nokia Corporation. All rights reserved.
> + *
> + * Author: Richard Purdie <rpurdie@openedhand.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */

Please use the same licence, and the same boilerplate, as the rest of
the JFFS2 code.

-- 
dwmw2

