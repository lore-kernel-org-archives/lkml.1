Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCHWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCHWHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbZCHWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:07:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZCHWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:07:39 -0400
Message-ID: <49B44182.1030707@zytor.com>
Date: Sun, 08 Mar 2009 15:06:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com> <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com> <49B436E4.1050103@kernel.org> <20090308220100.GO25995@parisc-linux.org>
In-Reply-To: <20090308220100.GO25995@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 02:21:40PM -0700, Yinghai Lu wrote:
>> Jesse or Matthew, can you pick this patch?
> 
> Having reviewed it in light of HPA's comment, I don't have a problem
> with it:
> 
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> 
> However, I don't think it's my place to take this patch while Jesse is
> away; it doesn't feel like it's needed to be submitted between -rc7 and
> 2.6.29.  Do you have a reason that it needs to be merged more urgently
> than 2.6.30-rc1?
> 

I didn't see one... I was assuming it was a submission to be pushed
upstream during the merge window.

It doesn't fix a regression, so it doesn't seem to me to be a case for a
late -rc merge.  It's hardware enablement, so it *might* qualify for
2.6.29-stable, as far as I understand Greg and Chris' policies.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

