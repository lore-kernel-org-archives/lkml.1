Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYJML2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYJML2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYJML2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:28:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55023 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263AbYJML2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:28:33 -0400
Date: Mon, 13 Oct 2008 13:27:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] block: add partition attribute for partition number
Message-ID: <20081013112751.GI19428@kernel.dk>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <48F00476.6030108@zytor.com> <48F3113F.7090905@kernel.org> <48F32BF6.8010109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F32BF6.8010109@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13 2008, Tejun Heo wrote:
> With extended devt, finding out the partition number becomes a bit
> more challenging as subtracting the minor number from that of the
> parent device doesn't work anymore.  The only thing left is parsing
> the partition name which is brittle and not exactly universal (some
> have '-' between the device name and partition number while others
> don't).  This patch introduced partition attribute which contains the
> partition number of the device.  This should make finding partitions
> and its index easier.
> 
> This problem and solution were suggested by H. Peter Anvin.

Applied to for-linus

-- 
Jens Axboe

