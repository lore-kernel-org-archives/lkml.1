Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYFDQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYFDQeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYFDQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:34:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYFDQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:34:12 -0400
Subject: Re: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
From: David Woodhouse <dwmw2@infradead.org>
To: matthias@kaehlcke.net
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080531132808.984625508@kaehlcke.net>
References: <20080531132808.644758754@kaehlcke.net>
	 <20080531132808.984625508@kaehlcke.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 17:34:08 +0100
Message-Id: <1212597248.32207.126.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-31 at 15:28 +0200, matthias@kaehlcke.net wrote:
> -                       struct list_head *this;
> +                       struct mtd_notifier *not

That's not even going to compile, surely?

-- 
dwmw2

