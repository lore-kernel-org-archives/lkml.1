Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXCMTSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXCMTSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXCMTSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:18:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbXCMTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:18:45 -0400
Date: Tue, 13 Mar 2007 19:18:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Zoltan Menyhart <Zoltan.Menyhart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Subject: Re: copy_one_pte()
Message-ID: <20070313191844.GA4206@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Zoltan Menyhart <Zoltan.Menyhart@free.fr>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	Zoltan Menyhart <Zoltan.Menyhart@bull.net>
References: <45F6F84D.20302@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6F84D.20302@free.fr>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 08:15:25PM +0100, Zoltan Menyhart wrote:
> I had a look at copy_one_pte().
> I cannot see any ioproc_update_page() call, not even for the COW pages.
> Is it intentional?

There is no such thing as ioproc_update_page in any mainline tree.
You must be looking at some vendor tree with braindead patches applied.

