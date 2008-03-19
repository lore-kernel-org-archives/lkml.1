Return-Path: <linux-kernel-owner+w=401wt.eu-S933687AbYCSXhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbYCSXhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbYCSWHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:07:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYCSWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:07:35 -0400
Date: Wed, 19 Mar 2008 15:07:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: clameter@sgi.com, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [0/2] vmalloc: Add /proc/vmallocinfo to display mappings
Message-Id: <20080319150704.d3f090e6.akpm@linux-foundation.org>
In-Reply-To: <20080319111943.0E1B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080318222701.788442216@sgi.com>
	<20080319111943.0E1B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 11:23:30 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
> > The following two patches implement /proc/vmallocinfo. /proc/vmallocinfo
> > displays data about the vmalloc allocations. The second patch introduces
> > a tracing feature that allows to display the function that allocated the
> > vmalloc area.
> > 
> > Example:
> > 
> > cat /proc/vmallocinfo

argh, please don't top-post.

(undoes it)

>
> Hi
> 
> Great.
> it seems very useful.
> and, I found no bug.
> 
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


I was just about to ask whether we actually need the feature - I don't
recall ever having needed it, nor do I recall seeing anyone else need it.

Why is it useful?
