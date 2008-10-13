Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYJMIsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYJMIsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYJMIrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:47:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50597 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbYJMIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:47:23 -0400
Date: Mon, 13 Oct 2008 10:46:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] block: add BIG FAT WARNING to CONFIG_DEBUG_BLOCK_EXT_DEVT
Message-ID: <20081013084642.GE19428@kernel.dk>
References: <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <20081011140826.GS19428@kernel.dk> <20081011143355.GA6274@elte.hu> <20081011143947.GT19428@kernel.dk> <20081011145823.GA14062@elte.hu> <20081011175818.GY19428@kernel.dk> <48F2ED9F.7020606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F2ED9F.7020606@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13 2008, Tejun Heo wrote:
> CONFIG_DEBUG_BLOCK_EXT_DEVT can break booting even on some modern
> distros.  Add BIG FAT WARNING to keep people at a safe distance.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Okay, w/ or w/o Ingo's change, it would be worthwhile to warn
> people more clearly so that we can at least say 'told ya'.  :-)
> 
>  lib/Kconfig.debug |    5 +++++
>  1 file changed, 5 insertions(+)

Agree, this looks appropriate. I'll add it.

-- 
Jens Axboe

