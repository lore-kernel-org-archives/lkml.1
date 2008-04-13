Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYDMIGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYDMIGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYDMIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:05:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYDMIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:05:55 -0400
Date: Sun, 13 Apr 2008 04:05:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080413080554.GC9622@infradead.org>
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.  Minor nitpick:

> +static void omfs_put_super(struct super_block *sb)
> +{
> +	struct omfs_sb_info *sbi = OMFS_SB(sb);
> +	if (sbi) {

This if check is no needed, as your fill_super method never returns
success without setting it up.

