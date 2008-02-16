Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYBPTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYBPTip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYBPTi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:38:27 -0500
Received: from www.tglx.de ([62.245.132.106]:41896 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYBPTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:38:26 -0500
Date: Sat, 16 Feb 2008 20:38:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Add warning when RTC clock reports binary 
In-Reply-To: <20080209151659.4F0EA1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802162037120.7583@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <20080209151659.4F0EA1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:

> 
> We tend to assume the RTC clock is BCD, so print a warning
> if it claims to be binary.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Applied. FYI, I changed it to a WARN_ON_ONCE. That will make reports
more likely.

Thanks,

	tglx
