Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZGFJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZGFJ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZGFJ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:28:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43673 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZGFJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:28:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262360907050751t1fccbf4t4ace572b4e003a13@mail.gmail.com>
References: <20090705211127.0917.A69D9226@jp.fujitsu.com> <28c262360907050751t1fccbf4t4ace572b4e003a13@mail.gmail.com>
Message-Id: <20090706182750.0C54.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Jul 2009 18:28:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ? ? ? ?printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> > - ? ? ? ? ? ? ? " inactive_file:%lu"
> > - ? ? ? ? ? ? ? " unevictable:%lu"
> > + ? ? ? ? ? ? ? " inactive_file:%lu unevictable:%lu isolated:%lu\n"
> 
> It's good.
> I have a one suggestion.
> 
> I know this patch came from David's OOM problem a few days ago.
> 
> I think total pages isolated of all lru doesn't help us much.
> It just represents why [in]active[anon/file] is zero.
> 
> How about adding isolate page number per each lru ?
> 
> IsolatedPages(file)
> IsolatedPages(anon)
> 
> It can help knowing exact number of each lru.

Good suggestion!
Will fix.


