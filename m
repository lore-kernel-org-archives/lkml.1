Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYAGMUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYAGMUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYAGMUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:20:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47918 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYAGMUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:20:02 -0500
Date: Mon, 7 Jan 2008 12:19:50 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] udf: check if udf_load_logicalvol failed
Message-ID: <20080107121950.GA3710@infradead.org>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com> <1199580275-2487-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199580275-2487-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:44:33AM +0100, marcin.slusarz@gmail.com wrote:
> +				ret = udf_load_logicalvol(sb, bh, fileset);
> +				if (ret != 0) {
> +					brelse(bh);
> +					return ret;
> +				}

This would be a simple if (ret) in normal Linux style if I'd want to
be picky, but the actual change look good.

