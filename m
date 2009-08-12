Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZHLPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZHLPcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZHLPcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:32:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbZHLPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:32:50 -0400
Date: Wed, 12 Aug 2009 08:32:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
 rcu_read_lock()
In-Reply-To: <1250079447.20332.27.camel@pc1117.cambridge.arm.com>
Message-ID: <alpine.LFD.2.01.0908120831060.28882@localhost.localdomain>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>  <20090802111453.GA24927@elte.hu>  <1249919718.10848.55.camel@pc1117.cambridge.arm.com>  <20090810184527.GA9601@elte.hu>  <1249945003.26205.23.camel@pc1117.cambridge.arm.com> 
 <20090811073205.GA17476@elte.hu>  <1249980905.27150.11.camel@pc1117.cambridge.arm.com> <1250079447.20332.27.camel@pc1117.cambridge.arm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Aug 2009, Catalin Marinas wrote:
> 
> If the object size is bigger than a predefined value (4K in this case),
> release the object lock during scanning and call cond_resched().

What guarantees that the object isn't released during this?

		Linus
