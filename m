Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZEXSqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZEXSqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZEXSqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:46:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZEXSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:46:38 -0400
Message-ID: <4A1995F0.6040602@zytor.com>
Date: Sun, 24 May 2009 11:46:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905240727.30677.lkml@morethan.org> <4A198B24.9040404@zytor.com> <200905241332.39946.lkml@morethan.org>
In-Reply-To: <200905241332.39946.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> 
> Note: I have seem to recall that newer gcc's optimizer presume 
> that the flags register is preserved across asm - 
> It didn't use to do that - but there is now a "cc" to deal with
> that - Have not yet audited for that, but it is high on my list.
> 

I am pretty sure that's false... if it was true we'd have failures all
over the kernel.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

