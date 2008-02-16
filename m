Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbYBPTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbYBPTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYBPTYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:24:50 -0500
Received: from www.tglx.de ([62.245.132.106]:51276 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYBPTYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:24:50 -0500
Date: Sat, 16 Feb 2008 20:24:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/5] Use 2000 offset for 32bit kernels
In-Reply-To: <20080209151658.4A3AD1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802162024220.7583@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <20080209151658.4A3AD1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:

> 
> We know it is already after 2000.
> 
> This extends the effective lifetime of 32bit systems by 8 years:
> from 2030 to 2038.
> 
> The only drawback is that users cannot set the cmos date to before 2000
> now on 32bit with systems that don't support extended century in 
> the RTC clock. 64bit systems had this limitation for some time
> and nobody complained.
> 
> And they can always set it to such a date in Linux only using date -s 
> if they really want.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Applied. Thanks,

	 tglx
