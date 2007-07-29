Return-Path: <linux-kernel-owner+w=401wt.eu-S934218AbXG2SnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbXG2SnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933433AbXG2Sm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:42:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46468 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbXG2Smz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:42:55 -0400
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to
	EXPORT_SYMBOL_GPL
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Steve Grubb <sgrubb@redhat.com>,
       linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070729150233.GX16817@stusta.de>
References: <20070729150233.GX16817@stusta.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 29 Jul 2007 11:40:33 -0700
Message-Id: <1185734433.346.33.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 17:02 +0200, Adrian Bunk wrote:
> This patch changes some completely unused audit exports from 
> EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
> 
> They are still completely unused, but hopefully some of the theoretical 
> code that might use it will appear in the kernel in the near future...
\

at least make them _UNUSED_ so that people can select to not have these
take up space...


