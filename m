Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZIIXdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZIIXdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZIIXdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:33:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZIIXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:33:12 -0400
Date: Wed, 9 Sep 2009 16:32:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, jpirko@redhat.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Message-Id: <20090909163212.11464d64.akpm@linux-foundation.org>
In-Reply-To: <20090910081020.9CAE.A69D9226@jp.fujitsu.com>
References: <20090907115430.6C16.A69D9226@jp.fujitsu.com>
	<20090909134643.5479b09e.akpm@linux-foundation.org>
	<20090910081020.9CAE.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 08:17:27 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> > The changelog had lots of ^------- lines in it.  But those are
> > conventionally the end-of-changelog separator so I rewrote them to
> > ^=======
> 
> sorry, I have stupid question.
> I thought "--" and "---" have special meaning. but other length "-" are safe.
> Is this incorrect?
> 
> or You mean it's easy confusing bad style?

Ideally, ^---$ is the only pattern we need to worry about.

In the real world, ^-------- might trigger people's sloppy scripts so
it's best to be safe and avoid it altogether.

