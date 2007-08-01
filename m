Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbXHAMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbXHAMgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763090AbXHAMgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:36:33 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2610 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762607AbXHAMgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:36:31 -0400
Date: Wed, 1 Aug 2007 08:24:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] prevent SSB compilation on s390 part 2
Message-ID: <20070801122409.GC5474@tuxdriver.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <20070801093404.GA12124@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801093404.GA12124@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:34:04AM +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> drivers/ssb/Kconfig has already a depends on HAS_IOMEM which should
> prevent SSB from being selected. But appearantly it looks like this
> doesn't matter at all if it gets selected from somewhere else.
> So add an explicit depends on HAS_IOMEM to the Broadcom driver to
> prevent selection on s390.
> 
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Note to reviewers: this is only relevant to -mm and wireless-dev at
the moment, AFAIK...

John
-- 
John W. Linville
linville@tuxdriver.com
