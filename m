Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbXIVIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbXIVIjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXIVIjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:39:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXIVIjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:39:02 -0400
Date: Sat, 22 Sep 2007 14:11:56 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com
Subject: Re: 2.6.23-rc6-mm1
In-Reply-To: <20070918174408.GC1804@skynet.ie>
Message-ID: <alpine.LFD.0.999.0709221409260.22517@enigma.security.iitk.ac.in>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070918174408.GC1804@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -static volatile int kgdb_hwbreak_sstep[NR_CPUS];
> +volatile int kgdb_hwbreak_sstep[NR_CPUS];

That looks fishy to me. Why is it volatile-qualified? And does that
actually want to be a per-cpu var?
