Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZJ3I4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZJ3I4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZJ3I4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:56:40 -0400
Received: from msa104.auone-net.jp ([61.117.18.164]:54395 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZJ3I4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:56:39 -0400
Date: Fri, 30 Oct 2009 17:56:41 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Don't ignore MS_RDONLY in bind and not remount
 case.
References: <20091030053146.BC2176FC03B@msa105.auone-net.jp>
 <20091030055337.GA3406@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030055337.GA3406@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20091030085644.2157915C033@msa104.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-10-30 01:53:37 -0400, Christoph Hellwig wrote:
> On Fri, Oct 30, 2009 at 02:31:46PM +0900, Kusanagi Kouichi wrote:
> > A readonly bind mount needed to be created in 2 steps
> > 
> > # mount --bind
> > # mount --bind -o remount,ro
> > 
> > instead of single
> > 
> > # mount --bind -o ro
> > 
> > because MS_RDONLY is ignored in bind and not remount case.
> 
> I'm pretty sure that was intentional, but I don't remember why anymore.

I could not find any reason to restrict this.
Could you tell me the reason of this restriction?
