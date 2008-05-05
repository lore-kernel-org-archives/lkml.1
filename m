Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYEELG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYEELG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYEELGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:06:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbYEELGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:06:49 -0400
Date: Mon, 5 May 2008 07:06:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 12/15] vfs: create file_truncate() helper
Message-ID: <20080505110646.GF20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095526.823086058@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095526.823086058@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:53AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Clean up do_truncate() API:
> 
>   - create a new function file_truncate()
>   - remove the 'struct file *' argument from do_truncate()

file_truncate looks like a nice little cleanup, but please make sure to
add a kerneldoc comment for every newly added global function.

I don't think there's a point to remove the file argument from
do_truncate and add another helper.

