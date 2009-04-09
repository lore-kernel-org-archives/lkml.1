Return-Path: <linux-kernel-owner+w=401wt.eu-S935165AbZDIPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbZDIPrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZDIPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:47:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbZDIPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:47:30 -0400
Date: Thu, 9 Apr 2009 11:47:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
Message-ID: <20090409154726.GA24959@infradead.org>
References: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp> <20090409150843.GA3111@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409150843.GA3111@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 05:08:43PM +0200, Johannes Weiner wrote:
> Which filesystem does that?  Shouldn't the filesystem get changed
> instead?

Yeah, if at all we should reject a name with those characters.  But I
feel that's a little over-engineering and we should just make sure no
in-tree fs does stupid things like that by review.

