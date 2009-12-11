Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbZLKIC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbZLKIC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbZLKICv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:02:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56931 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZLKICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:02:50 -0500
Date: Fri, 11 Dec 2009 17:02:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] sh: fix DMA driver's descriptor chaining and cookie assignment
Message-ID: <20091211080254.GB7625@linux-sh.org>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange> <Pine.LNX.4.64.0912101833170.4487@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912101833170.4487@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 06:35:11PM +0100, Guennadi Liakhovetski wrote:
> The SH DMA driver wrongly assigns negative cookies to transfer descriptors,
> also, its chaining of partial descriptors is broken. The latter problem is
> usually invisible, because maximum transfer size per chunk is 16M, but if you
> artificially set this limit lower, the driver fails. Since cookies are also
> used in chunk management, both these problems are fixed in one patch. As side
> effects a possible memory leak, when descriptors are prepared, but not
> submitted, and multiple races have also been fixed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Looks good to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
