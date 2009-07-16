Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbZGPQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbZGPQZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbZGPQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:25:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbZGPQZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:25:43 -0400
Message-ID: <4A5F5454.8070300@redhat.com>
Date: Thu, 16 Jul 2009 12:24:52 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
References: <20090716133454.GA20550@localhost> <4987.1247760908@redhat.com>
In-Reply-To: <4987.1247760908@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
>> It can greatly (and correctly) increase the slab scan rate under high memory
>> pressure (when most file pages have been reclaimed and swap is full/absent),
>> thus avoid possible false OOM kills.
> 
> I applied this to my test machine's kernel and rebooted.  It hit the OOM
> killer a few seconds after starting msgctl11 .  Furthermore, it was not then
> responsive to SysRq+b or anything else and had to have the magic button
> pushed.

It's part of a series of patches, including the three
posted by Kosaki-san last night (to track the number
of isolated pages) and the patch I posted last night
(to throttle reclaim when too many pages are isolated).

-- 
All rights reversed.
