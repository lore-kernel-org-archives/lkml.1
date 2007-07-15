Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbXGOIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbXGOIB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbXGOIBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 04:01:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53263 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbXGOIBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 04:01:19 -0400
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070714213412.GA10196@aepfle.de>
References: <20070714205709.GA9478@aepfle.de> <46993C59.1030902@zytor.com>
	 <20070714213412.GA10196@aepfle.de>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 09:01:11 +0100
Message-Id: <1184486471.2860.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 23:34 +0200, Olaf Hering wrote:
> > I would think it would be better to not define it at all.  Several
> > architectures already don't have PAGE_SIZE visible to userspace in 
> > any way.
> 
> i386 has it, so everyone uses it.

PowerPC lacks it, so nothing we ship in Fedora relies upon it.

Just kill it. Probably by leaving <asm/page.h> empty for now; we can
remove it completely later.

-- 
dwmw2

