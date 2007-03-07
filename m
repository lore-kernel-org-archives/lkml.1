Return-Path: <linux-kernel-owner+w=401wt.eu-S1422668AbXCGJhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668AbXCGJhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422670AbXCGJhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:37:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422668AbXCGJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:37:11 -0500
Date: Wed, 7 Mar 2007 09:37:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 1/6] UDF cleanup and fixes
Message-ID: <20070307093710.GA14863@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	akpm@osdl.org
References: <20070306164447.GC3661@duck.suse.cz> <20070306164638.GD3661@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164638.GD3661@duck.suse.cz>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 05:46:38PM +0100, Jan Kara wrote:
>   Use sector_t and loff_t for file offsets in UDF filesystem. Otherwise
> an overflow may occur for long files. Also make inode_bmap() return offset in
> the extent in number of blocks instead of number of bytes - for most callers
> this is more convenient.

Looks good, but can you make sure to add line breaks after 80 chars in
all the lines you touch?
