Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbZD1IDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbZD1IDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbZD1IDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:03:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51960 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbZD1IDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:03:12 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <1240904919.7620.73.camel@twins>
References: <20090428143019.EBBF.A69D9226@jp.fujitsu.com> <1240904919.7620.73.camel@twins>
Message-Id: <20090428170214.EBD8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 17:03:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1. please post your /proc/meminfo
> > 2. Do above copy make tons swap-out? IOW your disk read much faster than write?
> > 3. cache limitation of memcgroup solve this problem?
> > 4. Which disk have your /bin and /usr/bin?
> > 
> 
> FWIW I fundamentally object to 3 as being a solution.

Yes, I also think so.


> I still think the idea of read-ahead driven drop-behind is a good one,
> alas last time we brought that up people thought differently.

hmm.
sorry, I can't recall this patch. do you have any pointer or url?



