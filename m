Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYHNUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYHNUVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHNUVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:21:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYHNUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:21:31 -0400
Date: Thu, 14 Aug 2008 16:21:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc3] XFS logbsize/logbufs option problem...
Message-ID: <20080814202130.GB4509@infradead.org>
References: <6278d2220808141255g75618548qa7381e5569805646@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220808141255g75618548qa7381e5569805646@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 08:55:31PM +0100, Daniel J Blueman wrote:
> When the logbsize (eg =256k) or logbufs (eg =8) XFS mount options are
> present in /etc/fstab, the filesystem fails to mount r/w with
> 2.6.27-rc3, so stays read-only.
> 
> This seems to be a regression over 2.6.27-rc1 (didn't check -rc2). I'm
> testing on Ubuntu Intrepid x86-64, thus filesystem was constructed
> with xfsprogs 2.9.8-1.
> 
> Have you seen encountered this issue at all?

Yes, this is a known issues, and I have a patch for it that I'm about
to resubmit after fixing up some comments.

