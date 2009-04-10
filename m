Return-Path: <linux-kernel-owner+w=401wt.eu-S937623AbZDJQys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937623AbZDJQys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937372AbZDJQyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:54:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937368AbZDJQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:54:03 -0400
Date: Fri, 10 Apr 2009 12:54:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions
Message-ID: <20090410165401.GA20673@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org> <7612.1239382035@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7612.1239382035@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 01:47:15AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Christoph Hellwig:
> > Strong NACK to all these exports, no one has any buesiness looking at
> > these.
> 
> Will you tell me why?
> If you have ever discussed exporting lookup_hash(), then please tell me
> its URL or something.
> 
> lookup_hash is necessary for aufs since,

All these are vfs-internal bits, and there is no way we are going to
export them.  aufs does a lot of really weird things like this because
it's doing things in a filesystem that should be done in the VFS.

Just making sure these exports aren't going to accidentally put in if
Greg happens to suck this pile into the staging tree.
