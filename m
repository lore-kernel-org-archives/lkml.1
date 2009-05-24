Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZEXSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZEXSAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZEXSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:00:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZEXSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:00:33 -0400
Message-ID: <4A198B24.9040404@zytor.com>
Date: Sun, 24 May 2009 11:00:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <200905240727.30677.lkml@morethan.org>
In-Reply-To: <200905240727.30677.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> 
> @hpa - I still like your suggestion that it is only one (or a few)
> uses of atomic ops that is incorrect and in general atomic ops
> should compile away on uni-processor.
> 

Actually, the more I think about it the more I suspect there is a race
condition either in the chip set or in any VIA-specific drivers (if
there are any.)  Putting LOCKs in random places will slow the CPU down
significantly, so it might resolve the race condition without actually
solving the problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

