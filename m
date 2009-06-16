Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZFPOec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZFPOec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZFPOeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:34:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZFPOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:34:22 -0400
Date: Tue, 16 Jun 2009 10:34:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize
	(version 3)
Message-ID: <20090616143424.GA22002@infradead.org>
References: <1245088797-29533-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245088797-29533-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:59:47PM +0200, Jan Kara wrote:
> 
> patches below are an attempt to solve problems filesystems have with
> page_mkwrite() when blocksize < pagesize (see the changelog of the second patch
> for details).

It would be useful if you had a test case reproducing these issues,
so that I can verify how well your patches work in various scenarios.

