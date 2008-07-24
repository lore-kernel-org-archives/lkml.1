Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYGXUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYGXUep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYGXUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:34:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbYGXUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:34:33 -0400
Date: Thu, 24 Jul 2008 13:30:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724202728.GL14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
 <20080724202728.GL14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
>
> Only the first init_fpu() can fail (memory allocation failure). But here,
> it is def not the first time.

Ahh. Agreed. I missed that. But yes, clear_fpu() is still preferable, I 
think.

		Linus
