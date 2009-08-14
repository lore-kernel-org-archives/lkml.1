Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZHNWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZHNWp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZHNWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:45:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50706 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbZHNWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:45:26 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence
	byrcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090812205215.GA21451@elte.hu>
References: <20090812205215.GA21451@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 14 Aug 2009 23:45:13 +0100
Message-Id: <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2009 22:45:14.0858 (UTC) FILETIME=[E3A864A0:01CA1D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, 2009-08-12 at 21:52 +0100, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > kmemleak: Allow rescheduling during an object scanning
> 
> i tried this in -tip testing, and it crashes quickly:
> 
> [   81.900051] BUG: unable to handle kernel paging request at ffff880020000000
> [   81.901382] IP: [<ffffffff8112ae7e>] scan_block+0xee/0x190

I updated the original patch for cond_resched() slightly (to check for
objects they may be annotated during a scan_block loop). I also added a
patch with an annotation for the memory hole at 0x20000000 on your
x86_64 platform. I don't have such hardware to be able to check, so I
would be grateful if you can acknowledge them.

I'll post the patches as replies to this e-mail.

Thanks.

-- 
Catalin

