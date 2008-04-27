Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbYD0ScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbYD0ScR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbYD0Sb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:31:59 -0400
Received: from www.tglx.de ([62.245.132.106]:40413 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380AbYD0Sb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:31:59 -0400
Date: Sun, 27 Apr 2008 20:31:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Removal of FUTEX_FD (and related code)
In-Reply-To: <200804190207.14598.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0804272030380.3261@apollo.tec.linutronix.de>
References: <200804190207.14598.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Rusty Russell wrote:
> From: Eric Sesterhenn <snakebyte@gmx.de>
> Date: Fri, 25 Jan 2008 10:40:46 +0100
> 
> hi,
> 
> since FUTEX_FD was scheduled for removal in June 2007 lets remove it.
> Google Code search found no users for it and NGPT was abandoned in 2003
> according to IBM. futex.h is left untouched to make sure the id does
> not get reassigned. Since queue_me() has no users left it is commented
> out to avoid a warning, i didnt remove it completely since it is part
> of the internal api (matching unqueue_me())
> 
> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (removed rest)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
