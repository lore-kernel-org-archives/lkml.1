Return-Path: <linux-kernel-owner+w=401wt.eu-S935983AbZDJRFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935983AbZDJRFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbZDJRFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:05:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZDJRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:05:07 -0400
Date: Fri, 10 Apr 2009 13:05:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions
Message-ID: <20090410170506.GA29152@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org> <7612.1239382035@jrobl> <20090410165401.GA20673@infradead.org> <8041.1239382994@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8041.1239382994@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 02:03:14AM +0900, hooanon05@yahoo.co.jp wrote:
> If I stop exporting lookup_hash() and replace it by vfs_path_lookup(),
> will you review aufs patches again?

No, we've always said that we want to do vfs-level union mounts, and
at the storage summit we've actually moved forward on that and Jan
and Val are sorting some of the remaining issues now.

