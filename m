Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbXLaJRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbXLaJRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 04:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbXLaJRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 04:17:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57976 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXLaJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 04:17:36 -0500
Date: Mon, 31 Dec 2007 09:17:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071231091732.GA29043@infradead.org>
References: <20071230190619.GA13757@joi> <20071230191825.GA6447@infradead.org> <20071230214857.GA14177@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230214857.GA14177@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 10:49:34PM +0100, Marcin Slusarz wrote:
> I found it in XFS only. Did I miss something?

These helpers come from ocfs2 which has both be and le variants.

> be32_add is shorter than be32_add_cpu but I think it's not clear
> whether second parameter is in native byte order or not.

Then again adding foreing endian values doesn't make much sense.

If you insist on your naming please make sure to convert ocfs and xfs
to your naming.
