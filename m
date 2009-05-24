Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZEXTJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZEXTJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZEXTJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:09:43 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:55493 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZEXTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:09:43 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 14:09:40 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905241332.39946.lkml@morethan.org> <4A1995F0.6040602@zytor.com>
In-Reply-To: <4A1995F0.6040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905241409.42563.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > Note: I have seem to recall that newer gcc's optimizer presume 
> > that the flags register is preserved across asm - 
> > It didn't use to do that - but there is now a "cc" to deal with
> > that - Have not yet audited for that, but it is high on my list.
> > 
> 
> I am pretty sure that's false... if it was true we'd have failures all
> over the kernel.
> 

Not an issue at the moment, will cover that when I audit my own code.

Mike
> 	-hpa
> 


