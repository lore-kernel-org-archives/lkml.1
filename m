Return-Path: <linux-kernel-owner+w=401wt.eu-S1030337AbXAaRTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337AbXAaRTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXAaRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:19:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38706 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030337AbXAaRTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:19:45 -0500
Subject: Re: linux scheduler and "cache-mate" processors
From: Arjan van de Ven <arjan@infradead.org>
To: "Linda W." <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45B7F567.7020100@tlinx.org>
References: <45B7F567.7020100@tlinx.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 31 Jan 2007 18:17:20 +0800
Message-Id: <1170238640.2865.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) does the scheduler know enough to try to spread tasks
> equally over both the pairs to make best use of the 16MB total
> cache? (i.e. given cpu bound processes "1" and "2", if they
> are both on CPU "A", then the "C-D" cache remains unused, but
> keeping "1" on "a" and "2" on "C" would tend to minimize
> their caches being consumed by each other.

yes this works just fine


> 2) Since either A&B both have access to the 8MB cache, then
> if a process was running on "A", it seems it would have a
> low migration cost to be scheduled on "B" -- i.e. shouldn't
> the process, if it were migrated to "A"'s "cache-mate", "B",
> be able to benefit by any previous caching done on "A"? 
> If that's true, does the scheduler give preference, when
> migrating a process, to a CPU's "cache-mate"? 

afaik yes as well


