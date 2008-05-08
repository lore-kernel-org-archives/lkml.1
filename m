Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYEHNeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYEHNeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYEHNeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:34:36 -0400
Received: from www.tglx.de ([62.245.132.106]:51541 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYEHNee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:34:34 -0400
Date: Thu, 8 May 2008 15:33:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
In-Reply-To: <20080508131149.GB7718@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805081528430.3318@apollo.tec.linutronix.de>
References: <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org>
 <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de> <20080508131149.GB7718@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Adrian Bunk wrote:
> 
> This still has the inconsistent handling of future CPUs between AMD
> and Intel.
> 
> IMHO we should also assume for future AMD CPUs that PAT will work until 
> proven otherwise.

Right, I did not change the logic of that. This code is an interim
protection anyway, so we should be able to remove it _before_ new AMDs
hit the wild.

Thanks,

	tglx
