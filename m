Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbZHUR2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbZHUR2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbZHUR2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:28:09 -0400
Received: from verein.lst.de ([213.95.11.210]:56102 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813AbZHUR2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:28:07 -0400
Date: Fri, 21 Aug 2009 19:28:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
       linux-fsdevel@vger.kernel.org, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: [PATCH 13/17] xfs: Convert sync_page_range() to simple fdatawrite_range()
Message-ID: <20090821172801.GA30254@lst.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-14-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-14-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:24:03PM +0200, Jan Kara wrote:
> +		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);

I think this should be a filemap_write_and_wait_range

