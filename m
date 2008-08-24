Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYHXMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYHXMi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYHXMit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 08:38:49 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58762 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYHXMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 08:38:48 -0400
Date: Sun, 24 Aug 2008 13:38:34 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zev Weiss <zevweiss@gmail.com>, Rodolfo@shareable.org,
       David Woodhouse <dwmw2@infradead.org>, Giometti <giometti@enneenne.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
Message-ID: <20080824123834.GC24946@shareable.org>
References: <48ABCC0B.40607@gmail.com> <20080822153451.bb79bd1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822153451.bb79bd1f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> struct mtd_erase_region_info {
> 	struct {
> 		u_int32_t offset;
> 		u_int32_t erasesize;
> 		u_int32_t numblocks;
> 	} user_part;
> 	unsigned long *lockmap;
> };

Is the name "struct mtd_erase_region_info" something userspace uses?

Nothing wrong with changing the kernel's version, as long as userspace
uses different headers, but it might be confusing.

-- Jamie
