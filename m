Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZGARQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZGARQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZGARQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:16:45 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53364 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295AbZGARQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:16:44 -0400
Date: Wed, 1 Jul 2009 13:16:27 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Howells <dhowells@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
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
Subject: Re: [PATCH v2] Show kernel stack usage to /proc/meminfo and OOM
 log
In-Reply-To: <10604.1246459458@redhat.com>
Message-ID: <alpine.DEB.1.10.0907011315540.9522@gentwo.org>
References: <20090701103622.85CD.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0906301011210.6124@gentwo.org> <20090701082531.85C2.A69D9226@jp.fujitsu.com> <10604.1246459458@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, David Howells wrote:

> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
> > +	int pages = THREAD_SIZE / PAGE_SIZE;
>
> Bad assumption.  On FRV, for example, THREAD_SIZE is 8K and PAGE_SIZE is 16K.

Guess that means we need arch specific accounting for this counter.

