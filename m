Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYKPRfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYKPRfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYKPRf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:35:26 -0500
Received: from lazybastard.de ([212.112.238.170]:49588 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYKPRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:35:25 -0500
Date: Sun, 16 Nov 2008 18:34:54 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Message-ID: <20081116173453.GA703@logfs.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 November 2008 18:38:53 -0500, Mike Frysinger wrote:
> 
> Rather than having every map/mtd driver doing the same sequence of
> registering partitions and/or devices, implement common parse_mtd().

I just added partitioning support to block2mtd.  Looks like I might
rethink the patch. :)

> @@ -292,6 +292,43 @@ void put_mtd_device(struct mtd_info *mtd)
>  	module_put(mtd->owner);
>  }
>  
> +#include <linux/mtd/partitions.h>

#include in the middle of the code?

Jörn

-- 
Happiness isn't having what you want, it's wanting what you have.
-- unknown
