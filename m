Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbZCMRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbZCMRiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbZCMRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:38:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701AbZCMRiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:38:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
To: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com
Date: Fri, 13 Mar 2009 17:33:43 +0000
Message-ID: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first patch causes the mlock() bits added by CONFIG_UNEVICTABLE_LRU to be
unavailable in NOMMU mode.

The second patch makes CONFIG_UNEVICTABLE_LRU available in NOMMU mode.

David
