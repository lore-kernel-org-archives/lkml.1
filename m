Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZFYU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZFYU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZFYU0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:26:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFYU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:26:40 -0400
Date: Thu, 25 Jun 2009 22:26:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090625202642.GX6760@one.firstfloor.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org> <4A43871F.9030507@zytor.com> <20090625195408.GW6760@one.firstfloor.org> <4A43DAFD.90409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A43DAFD.90409@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know why, but in the configuration I saw each percpu area was
> something like 1.8 MB.

That sounds like something that needs to be investigated and fixed then.
In a sense per cpu space is precious like stack space and shouldn't 
be wasted.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
