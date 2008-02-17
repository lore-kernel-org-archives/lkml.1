Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYBQNZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYBQNZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYBQNZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:25:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYBQNZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:25:38 -0500
Date: Sun, 17 Feb 2008 08:25:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6 patch] remove generic_commit_write()
Message-ID: <20080217132533.GB5777@infradead.org>
References: <20080217081637.GB3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217081637.GB3848@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:16:37AM +0200, Adrian Bunk wrote:
> This patch removes the obsolete and no longer used generic_commit_write().

Given that the APIs these are helpers for are gone this function should
go away.

ACK.

