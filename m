Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZJ3Fxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZJ3Fxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZJ3Fxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:53:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZJ3Fxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:53:33 -0400
Date: Fri, 30 Oct 2009 01:53:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Don't ignore MS_RDONLY in bind and not remount
	case.
Message-ID: <20091030055337.GA3406@infradead.org>
References: <20091030053146.BC2176FC03B@msa105.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030053146.BC2176FC03B@msa105.auone-net.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 02:31:46PM +0900, Kusanagi Kouichi wrote:
> A readonly bind mount needed to be created in 2 steps
> 
> # mount --bind
> # mount --bind -o remount,ro
> 
> instead of single
> 
> # mount --bind -o ro
> 
> because MS_RDONLY is ignored in bind and not remount case.

I'm pretty sure that was intentional, but I don't remember why anymore.

