Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929Ab0AHP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab0AHP3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863Ab0AHP3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:29:54 -0500
Received: from lazybastard.de ([212.112.238.170]:49285 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0AHP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:29:53 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 10:29:53 EST
Date: Fri, 8 Jan 2010 16:29:45 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 9/9] mtd: Add new SmartMedia/xD FTL
Message-ID: <20100108152945.GC31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop> <1262963524.12577.23.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1262963524.12577.23.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 January 2010 17:12:04 +0200, Maxim Levitsky wrote:
> 
> This implements new readwrite SmartMedia/xd FTL.
> 
> It depends on nand driver to define proper oob layout that excludes
> all ecc areas and nothing more.
> 
> Support for very old 256 byte/page devices is not yet enabled/complete.
> For these devices, all ecc handling will be done inside this FTL
> due to wierd oob layout.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mtd/Kconfig  |   12 +
>  drivers/mtd/Makefile |    1 +
>  drivers/mtd/sm_ftl.c | 1043 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/sm_ftl.h |   75 ++++

sm_ftl is certainly nicer than ssfdc.c - at least I can decrypt the
acronym.  But I am missing a reason why ssfdc is not sufficient and we
need yet another implementation of the same ftl.

Or maybe ssfdc is sufficient or barely sufficient and just needs a small
patch?

Jörn

-- 
He that composes himself is wiser than he that composes a book.
-- B. Franklin
