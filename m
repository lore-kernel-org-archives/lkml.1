Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbYEMJBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbYEMJBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYEMJBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:01:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbYEMJBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:01:13 -0400
Date: Tue, 13 May 2008 05:01:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] fuse: add export operations
Message-ID: <20080513090108.GB23849@infradead.org>
References: <20080509124107.645600519@szeredi.hu> <20080509124133.577558326@szeredi.hu> <20080509194030.GA29118@infradead.org> <20080509194642.GA783@infradead.org> <E1Jvpxc-0000Tx-JU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jvpxc-0000Tx-JU@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:34:12AM +0200, Miklos Szeredi wrote:
> One suggestion I have for that patch: leave export_encode_fh() as is
> (or just rename got generic_encode_fh()), and introduce a new
> generic_encode64_fh().  One less magic boolean parameter to worry
> about, and there's very little shared code between those two anyway.

Yeah, probably makes sense to split them.

