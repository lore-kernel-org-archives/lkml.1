Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYKYXyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYKYXyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYKYXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:54:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbYKYXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:54:44 -0500
Date: Tue, 25 Nov 2008 15:54:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated
 statics.
Message-Id: <20081125155422.6ab07caf.akpm@linux-foundation.org>
In-Reply-To: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 12:22:53 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	if (scan_global_lru(sc))

mutter.  scan_global_lru() is a terrible function name.  Anyone reading
that code would expect that this function, umm, scans the global LRU.

gcc has a nice convention wherein such functions have a name ending in
"_p" (for "predicate").  Don't do this :)
