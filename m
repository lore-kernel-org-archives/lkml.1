Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZGCADg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZGCADg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZGCAD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:03:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48779 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZGCAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:03:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] Show kernel stack usage to /proc/meminfo and OOM log
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <4A4B9BA1.6040109@redhat.com>
References: <alpine.DEB.1.10.0907011315540.9522@gentwo.org> <4A4B9BA1.6040109@redhat.com>
Message-Id: <20090703090226.08E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Jul 2009 09:03:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Christoph Lameter wrote:
> > On Wed, 1 Jul 2009, David Howells wrote:
> > 
> >> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >>
> >>> +	int pages = THREAD_SIZE / PAGE_SIZE;
> >> Bad assumption.  On FRV, for example, THREAD_SIZE is 8K and PAGE_SIZE is 16K.
> > 
> > Guess that means we need arch specific accounting for this counter.
> 
> Or we count the number of stacks internally and only
> convert to pages whenever we display the value.

Thanks good idea. I'll implement this today (or tommorow).


