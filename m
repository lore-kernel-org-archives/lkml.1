Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYFSRWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYFSRWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYFSRV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:21:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYFSRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:21:58 -0400
Subject: Re: [PATCH] jedec_probe: Fix SST 16-bit chip detection
From: David Woodhouse <dwmw2@infradead.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
References: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 18:21:53 +0100
Message-Id: <1213896113.26255.1434.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 16:36 +0900, Atsushi Nemoto wrote:
> -               .devtypes       = CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
> +               .devtypes       = CFI_DEVICETYPE_X16,

I believe you about the uaddr -- but can these devices really not be
used in 8-bit mode?

-- 
dwmw2

