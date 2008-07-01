Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYGAI2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYGAI2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGAI1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:27:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYGAI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:27:52 -0400
Date: Tue, 1 Jul 2008 04:27:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Zach Brown <zach.brown@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH]  aio: remove unused function aio_run_iocbs()
Message-ID: <20080701082738.GA1293@infradead.org>
References: <200806261640.27048.knikanth@suse.de> <x49lk0rt3x6.fsf@segfault.boston.devel.redhat.com> <48691AA2.7050201@oracle.com> <200807011355.51049.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011355.51049.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 01:55:50PM +0530, Nikanth Karthikesan wrote:
> Can't this function be kept as part of the out-of-tree patch itself? Or is it 
> a module that requires this symbol? I do not see a EXPORT_SYMBOL*() for this, 
> so it cannot be a module depending on this func!?

Yes.  There's very very few reason to keep unused functions around,
and a patch that hasn't been merged forever is not one of those.

Please kill it.

