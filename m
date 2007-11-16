Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbXKPTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbXKPTQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXKPTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:16:36 -0500
Received: from koto.vergenet.net ([210.128.90.7]:39742 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbXKPTQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:16:35 -0500
Date: Fri, 16 Nov 2007 11:16:30 -0800
From: Simon Horman <horms@verge.net.au>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: Re: [PATCH 5/5] Add the array length of "free_list" for filtering free pages
Message-ID: <20071116191624.GD8971@verge.net.au>
References: <473CFE14.3010400@mxs.nes.nec.co.jp> <473D0176.6090702@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <473D0176.6090702@mxs.nes.nec.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:33:26AM +0900, Ken'ichi Ohmichi wrote:
> 
> This patch adds the array length of "free_area.free_list" to the vmcoreinfo
> data so that makedumpfile (dump filtering command) can exclude all free pages
> in linux-2.6.24.
> 
> makedumpfile creates a small dumpfile by excluding unnecessary pages for the
> analysis. To distinguish unnecessary pages, makedumpfile gets the vmcoreinfo
> data which has the minimum debugging information only for dump filtering.
> 
> In 2.6.24-rc1 or later, the free_area.free_list is an array which has one list
> for each migrate types instead of a single list. makedumpfile needs the array
> length of "free_area.free_list" and the vmcoreinfo data should contain it.
> 
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Tested-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

This seems fine to me. Though from a point of maintainability
would it be better if VMCOREINFO_LENGTH derived the length
from the element of the type in question. Just a thought,
I haven't hacked it up to see how practical it might be.

Acked-by: Simon Horman <horms@verge.net.au>
