Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYAPCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYAPCF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYAPCFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:05:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60139 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYAPCFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:05:47 -0500
Date: Wed, 16 Jan 2008 11:05:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: [RFC] mmaped copy too slow?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <478CAB25.30300@grupopie.com>
References: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com> <478CAB25.30300@grupopie.com>
Message-Id: <20080116110200.11B4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paulo

> One thing you could also try is to pass MAP_POPULATE to mmap so that the 
> page tables are filled in at the time of the mmap, avoiding a lot of 
> page faults later.
> 
> Just my 2 cents,

OK, I will test your idea and report about tomorrow.
but I don't think page fault is major performance impact.

may be, below 2 things too big
  - stupid page reclaim
  - large cache pollution by memcpy.

Just my 2 cents :-p


- kosaki


