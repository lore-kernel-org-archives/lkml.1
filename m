Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYJJRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYJJRSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbYJJRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:18:36 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:9616 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbYJJRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:18:34 -0400
X-IronPort-AV: E=Sophos;i="4.33,390,1220227200"; 
   d="scan'208";a="48576722"
From: Roland Dreier <rdreier@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	<20081009211837.GC18444@colo.lackof.org>
	<20081010114002D.fujita.tomonori@lab.ntt.co.jp>
	<200810100848.09557.jbarnes@virtuousgeek.org>
	<86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
	<20081010163350.GF25780@parisc-linux.org>
	<48EF86E9.8030408@kernel.org>
	<20081010171214.GG25780@parisc-linux.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 10 Oct 2008 10:18:33 -0700
In-Reply-To: <20081010171214.GG25780@parisc-linux.org> (Matthew Wilcox's
	message of "Fri, 10 Oct 2008 11:12:15 -0600")
Message-ID: <ada1vyojrme.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Oct 2008 17:18:33.0578 (UTC) FILETIME=[39276CA0:01C92AFC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Open-coding DMA_BIT_MASK() within your driver means that we no longer
 > have a canonical list of DMA masks in one place.  Instead we have to
 > grep the entire tree and come up with more-or-less complex scripts to
 > figure out which bit masks are actually in use.

Out of curiousity, why do we care about that list?

 - R.
