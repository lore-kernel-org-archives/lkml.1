Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbZD3RQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbZD3RQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764141AbZD3RHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764366AbZD3RH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:28 -0400
Message-ID: <49F9D9C4.8040105@zytor.com>
Date: Thu, 30 Apr 2009 10:03:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu>
In-Reply-To: <20090430154051.GA3346@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Makes sense. One question would be X86_L1_CACHE_SHIFT - you set it 
> to 2^6 == 64 - that's correct i think, most Atoms come with 64 byte 
> L2 cache AFAIK.
> 
> I've Cc:-ed Intel folks - is this assumption about 64 bytes correct?
> 

Seems to be.  At least that's what CPUID reports.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

