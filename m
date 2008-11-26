Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYKZANq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYKZANq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYKZANh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:13:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49996 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYKZANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:13:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated statics.
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20081125155422.6ab07caf.akpm@linux-foundation.org>
References: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081125155422.6ab07caf.akpm@linux-foundation.org>
Message-Id: <20081126091027.3CA6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 26 Nov 2008 09:13:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 25 Nov 2008 12:22:53 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +	if (scan_global_lru(sc))
> 
> mutter.  scan_global_lru() is a terrible function name.  Anyone reading
> that code would expect that this function, umm, scans the global LRU.

yup.

> gcc has a nice convention wherein such functions have a name ending in
> "_p" (for "predicate").  Don't do this :)

however, "_p" isn't linux convention.
so, I like "is_" or "can_" (or likes somethingelse) prefix :)



