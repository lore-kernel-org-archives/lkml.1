Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0CHXxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:53:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46652 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab0CHXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:53:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Mar 2010 08:50:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: sync_mm_rss() issues
Message-Id: <20100309085012.46c28722.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <30859.1268056796@redhat.com>
References: <30859.1268056796@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Mar 2010 13:59:56 +0000
David Howells <dhowells@redhat.com> wrote:

> 
> There are a couple of issues with sync_mm_rss(), as added by patch:
> 
> 	commit 34e55232e59f7b19050267a05ff1226e5cd122a5
> 	Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 	Date:   Fri Mar 5 13:41:40 2010 -0800
> 	Subject: mm: avoid false sharing of mm_counter
> 
>  (1) You haven't implemented it for NOMMU mode.  What's the right way to do
>      this?  Just give an empty function?
> 
Ah, sorry. I'll prepare empty function immediately. But I have no NOMMU
enviroment...


>  (2) linux/mm.h should carry the empty function as an inline when
>      CONFIG_SPLIT_RSS_COUNTING=n, rather than it being defined as an empty
>      function in mm/memory.c.
> 

ok.

please wait..

Sorry,
-Kame

