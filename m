Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYJNPPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYJNPPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYJNPPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:15:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYJNPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:15:35 -0400
Date: Tue, 14 Oct 2008 11:15:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] block: add BIG FAT WARNING to
	CONFIG_DEBUG_BLOCK_EXT_DEVT
Message-ID: <20081014151526.GA30205@infradead.org>
References: <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <20081011140826.GS19428@kernel.dk> <20081011143355.GA6274@elte.hu> <20081011143947.GT19428@kernel.dk> <20081011145823.GA14062@elte.hu> <20081011175818.GY19428@kernel.dk> <48F2ED9F.7020606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F2ED9F.7020606@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 03:41:35PM +0900, Tejun Heo wrote:
> CONFIG_DEBUG_BLOCK_EXT_DEVT can break booting even on some modern
> distros.  Add BIG FAT WARNING to keep people at a safe distance.

Just remove the whole "debug" code.  It clutters up all block drivers with
ifdefs and doesn't actually provide any benefit.

