Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYIAUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYIAUR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYIAURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:17:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:36729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYIAURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:17:50 -0400
Subject: Re: warning during mtd registration in 2.6.27-rc5
From: David Woodhouse <dwmw2@infradead.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       axboe@kernel.dk
In-Reply-To: <20080901142949.GA18081@doriath.ww600.siemens.net>
References: <20080901142949.GA18081@doriath.ww600.siemens.net>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 21:17:44 +0100
Message-Id: <1220300264.2982.140.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 18:29 +0400, Dmitry Baryshkov wrote:
> This happens when adding mtd partitions. I've traced it to the fact that
> mtd partition devices share the genhd queue with the whole chip block device.
> Thus blk_register_filter receives the same pointer for the chip and for each
> registered partition.

Yes, the fix for that is already on its way to Linus.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



