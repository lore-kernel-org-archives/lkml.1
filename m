Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYFROvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYFROvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYFROvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:51:06 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.68]:35635 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYFROvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:51:05 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 18 Jun 2008 23:50:25 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Message-Id: <20080618235025.6ced35f8.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20080618184000.a855dfe0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
	<20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
	<20080618184000.a855dfe0.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kamezawa-san.

Sorry for my late reply, and thank you for your patch.

> This patch tries to make putback_lru_pages() to be lock_page() free.
> (Of course, some callers must take the lock.)
> 
I like this idea.

I'll test it tomorrow.


Thanks,
Daisuke Nishimura.
