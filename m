Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZHEPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZHEPRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZHEPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:17:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZHEPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:17:52 -0400
Date: Wed, 5 Aug 2009 11:17:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de,
       xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer
	check
Message-ID: <20090805151750.GA16080@infradead.org>
References: <1249329808.7686.26.camel@logos> <20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos> <4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249411898.7576.19.camel@logos>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:51:38PM -0300, Ramon de Carvalho Valle wrote:
> The xfs_iformat function does not check if the realtime device target pointer
> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
> structure.

Same as Eric I don't think there's much of a point renumbering the error
cases.  Instead I'll do another patch with a couple of cleanups in this
function replacing all the numbers with short alphabetic tags.

I don't really see the point of printing the flags either, if we have
this bit flipped it's pretty clear that we had random corruption of this
dinode.

