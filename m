Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZGAPSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZGAPSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZGAPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:18:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZGAPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:18:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090701103622.85CD.A69D9226@jp.fujitsu.com>
References: <20090701103622.85CD.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0906301011210.6124@gentwo.org> <20090701082531.85C2.A69D9226@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Christoph Lameter <cl@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH v2] Show kernel stack usage to /proc/meminfo and OOM log
Date: Wed, 01 Jul 2009 15:44:18 +0100
Message-ID: <10604.1246459458@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	int pages = THREAD_SIZE / PAGE_SIZE;

Bad assumption.  On FRV, for example, THREAD_SIZE is 8K and PAGE_SIZE is 16K.

David
