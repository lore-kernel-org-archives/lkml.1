Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008Ab0AUI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0AUI47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854Ab0AUI46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:56:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0AUI46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:56:58 -0500
Date: Thu, 21 Jan 2010 03:56:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>,
       xfs@oss.sgi.com, Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: Circular locking dependency warning involing xfs on 2.6.27
Message-ID: <20100121085655.GA687@infradead.org>
References: <4B57ADB4.70002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57ADB4.70002@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 10:28:20AM +0900, Tejun Heo wrote:
> Hello,
> 
> This is on a pretty old kernel but Carsten reports that it happens
> occassionally in a pretty large setup involving 1500+ machines (please
> feel free to fill in).  This happens pretty sporadically so reporting
> it just in case this is a yet unknown problem.  As I understand it,
> testing with newer kernel isn't out of question but it being a
> production environment, not a very easy thing.

I think the one below is gone.  We still have a very similar one that
can only happen during unmount, and we're trying to sort that one at the
VFS level (see the current thread on -fsdevel)

