Return-Path: <linux-kernel-owner+w=401wt.eu-S935979AbXG2U0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935979AbXG2U0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934994AbXG2U0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:26:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934862AbXG2U0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:26:08 -0400
Date: Sun, 29 Jul 2007 21:26:03 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Steve Grubb <sgrubb@redhat.com>,
       linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to EXPORT_SYMBOL_GPL
Message-ID: <20070729202603.GA16503@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@stusta.de>, David Woodhouse <dwmw2@infradead.org>,
	Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	linux-kernel@vger.kernel.org
References: <20070729150233.GX16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729150233.GX16817@stusta.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 05:02:33PM +0200, Adrian Bunk wrote:
> This patch changes some completely unused audit exports from 
> EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
> 
> They are still completely unused, but hopefully some of the theoretical 
> code that might use it will appear in the kernel in the near future...

Please kill them.  We can add exports back once people add users for them.

