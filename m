Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYAGM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYAGM06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYAGM0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:26:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYAGM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:26:49 -0500
Date: Mon, 7 Jan 2008 12:26:35 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] udf: fix sparse warnings (shadowing & mismatch between
	declaration and definition)
Message-ID: <20080107122635.GC3710@infradead.org>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com> <1199580275-2487-7-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199580275-2487-7-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:44:35AM +0100, marcin.slusarz@gmail.com wrote:
> fix sparse warnings:
> fs/udf/super.c:1431:24: warning: symbol 'bh' shadows an earlier one
> fs/udf/super.c:1347:21: originally declared here
> fs/udf/super.c:472:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Looks good.

