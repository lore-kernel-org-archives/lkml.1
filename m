Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450Ab0AHPbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0AHPbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329Ab0AHPbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:31:23 -0500
Received: from lazybastard.de ([212.112.238.170]:49289 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0AHPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:31:22 -0500
Date: Fri, 8 Jan 2010 16:31:15 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/9] MTD: create lockless versions of {get,put}_mtd_device
Message-ID: <20100108153114.GD31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop> <1262963198.12577.16.camel@maxim-laptop> <20100108152119.GB31872@logfs.org> <1262964444.12577.29.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1262964444.12577.29.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 January 2010 17:27:24 +0200, Maxim Levitsky wrote:
> 
> Yep, you miss this:
> 
> +extern int __get_mtd_device(struct mtd_info *mtd);
> +extern void __put_mtd_device(struct mtd_info *mtd);
> 
> I put that into the header, so these functions can be used outside.
> 
> When I compiled the kernel, there were no warnings.

Maxim: 1
Joern: 0

Jörn

-- 
But this is not to say that the main benefit of Linux and other GPL
software is lower-cost. Control is the main benefit--cost is secondary.
-- Bruce Perens
