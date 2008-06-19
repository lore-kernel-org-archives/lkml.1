Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYFSJbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYFSJbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYFSJbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:31:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40124 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYFSJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:31:36 -0400
Date: Thu, 19 Jun 2008 18:31:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 5/5] putback_lru_page()/unevictable page handling rework v2
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080619181707.E80E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080619181707.E80E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080619182415.E811.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ah, sorry.
I forgot to write changelog.

V1 -> V2
   o undo unintented comment killing.
   o move putback_lru_page() from move_to_new_page() to unmap_and_move().
   o folded depend patch
       http://marc.info/?l=linux-mm&m=121337119621958&w=2
       http://marc.info/?l=linux-kernel&m=121362782406478&w=2
       http://marc.info/?l=linux-mm&m=121377572909776&w=2


> this patch is folding several patches and obsolete to
> 
> Lee's  "fix double unlock_page()" patches
> 
>    http://marc.info/?l=linux-mm&m=121337119621958&w=2
>    http://marc.info/?l=linux-kernel&m=121362782406478&w=2
> 
> and Nishimura-san's "remove redundant page->mapping check" patch.
> 
>    http://marc.info/?l=linux-mm&m=121377572909776&w=2
> 
> 
> -----------------------------------------
> From: KAMEZAWA Hiroyuki <kamezawa.hiroy@jp.fujitsu.com>


