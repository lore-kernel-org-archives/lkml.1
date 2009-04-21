Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZDUHEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZDUHEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZDUHEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:04:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53962 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZDUHED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:04:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only once
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421155256.F133.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 16:03:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> get_page_from_freelist() can be called multiple times for an allocation.
> Part of this calculates the preferred_zone which is the first usable
> zone in the zonelist. This patch calculates preferred_zone once.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

I'm not sure this patch improve performance largely or not.
but I don't find the bug.


	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




