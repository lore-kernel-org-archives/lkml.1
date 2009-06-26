Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZFZROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZFZROR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZFZROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:14:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:56211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:14:05 -0400
Subject: Re: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
From: David Woodhouse <dwmw2@infradead.org>
To: vimal singh <vimalsingh@ti.com>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>
In-Reply-To: <57946.192.168.10.89.1246035773.squirrel@dbdmail.itg.ti.com>
References: <53729.192.168.10.89.1246035472.squirrel@dbdmail.itg.ti.com>
	 <57946.192.168.10.89.1246035773.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 18:14:02 +0100
Message-Id: <1246036442.663.47.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 22:32 +0530, vimal singh wrote:
> Somehow I do not see below errors on compilation:
> drivers/mtd/nand/omap2.c: In function 'omap_wait':
> drivers/mtd/nand/omap2.c:543: error: 'jiffies' undeclared (first use in this
> function)
> drivers/mtd/nand/omap2.c:543: error: (Each undeclared identifier is reported
> only once
> drivers/mtd/nand/omap2.c:543: error: for each function it appears in.)
> drivers/mtd/nand/omap2.c:557: error: implicit declaration of function
> 'time_before'
> 
> But still including 'linux/jiffies.h'.
> 
> Below is the patch.

The 'status' you return in the case that you _have_ gone through the
loop is still wrong though, isn't it?

-- 
dwmw2

