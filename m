Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZELSEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZELSEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZELSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:03:43 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46597 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952AbZELSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:03:42 -0400
Date: Tue, 12 May 2009 18:02:21 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
 pages from reclaim
In-Reply-To: <4A09B46D.9010705@redhat.com>
Message-ID: <alpine.DEB.1.10.0905121801080.19973@qirst.com>
References: <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025246.GC7518@localhost> <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com> <4A09AC91.4060506@redhat.com> <alpine.DEB.1.10.0905121718040.24066@qirst.com>
 <4A09B46D.9010705@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Rik van Riel wrote:

> > Streaming I/O means access once?
>
> Yeah, "used-once pages" would be a better criteria, since
> you could go through a gigantic set of used-once pages without
> doing linear IO.

Can we see some load for which this patch has a beneficial effect?
With some numbers?

