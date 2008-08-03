Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYHCI5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYHCI5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYHCI5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:57:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58680 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYHCI5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:57:02 -0400
Subject: Re: [PATCH] drivers/video/console/promcon.c: fix build error
From: David Woodhouse <dwmw2@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: tim.bird@am.sony.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080802230357.GE4856@orion>
References: <20080802230357.GE4856@orion>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 09:56:56 +0100
Message-Id: <1217753816.2500.13.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 03:03 +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> drivers/video/console/promcon.c: fix build error
> 
> drivers/video/console/promcon.c:158: error: implicit declaration of
> function 'con_protect_unimap'
> 
> Introduced by commit 4744b43431e8613f920c5cba88346756f53c5165

Commit a29ccf6f823a84d89e1c7aaaf221cf7282022024, surely? 

And in fact it looks like we could remove those parts of promcon.c
completely if !CONFIG_CONSOLE_TRANSLATIONS. But your patch is certainly
correct, and I've applied it to my 'random-2.6.git' tree which I've
already asked Linus to pull.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

