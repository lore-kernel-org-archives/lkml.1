Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbXK3TXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbXK3TXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXK3TXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:23:14 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1845 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbXK3TXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:23:13 -0500
Subject: Re: RFC - organize include/linux/kernel.h, add
	include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711301908430.18767@fbirervta.pbzchgretzou.qr>
References: <20071130092842.GA6221@localhost.sw.ru>
	 <1196445871.22120.178.camel@localhost>
	 <Pine.LNX.4.64.0711301908430.18767@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 11:20:53 -0800
Message-Id: <1196450453.22120.199.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 19:09 +0100, Jan Engelhardt wrote:
> While you are at that, PFX should probably be KBUILD_MODNAME,
> for simplicity. Then it will be easy to consolidate since
> they all use KBUILD_MODNAME rather than their own PFX.
> Just btw :)

I think that nearly all private logging functions
could be eliminated by having a new macro defined
especially for logging.

Something akin to:

#define PRINTK_MODNAME  1
#define PRINTK_FILE     2
#define PRINTK_FUNCTION 4
#define PRINTK_LINE     8

#define PRINTK_PREFIX (your choice)
#include <linux/logging.h>

then all uses of pr_<level> could get modified for free.


