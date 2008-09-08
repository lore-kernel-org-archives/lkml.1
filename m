Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYIHXoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYIHXoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYIHXny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:43:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46070 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYIHXnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:43:53 -0400
Date: Tue, 09 Sep 2008 08:43:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] mm: ifdef Quicklists in /proc/meminfo
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809081351240.4983@blonde.site>
References: <Pine.LNX.4.64.0809081351240.4983@blonde.site>
Message-Id: <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A "Quicklists:          0 kB" line has just started appearing in
> /proc/meminfo, but most architectures (including x86) don't have
> them configured: may we please #ifdef it, like the highmem lines?
> 
> And those architectures which do have quicklists configured are
> using them for page tables: so let's place it next to PageTables.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---

Oh, I see.
Thanks Hugh.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



