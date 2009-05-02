Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZEBDKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZEBDKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZEBDKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:10:09 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.68]:53881 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZEBDKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:10:08 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 2 May 2009 12:09:19 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: nishimura@mxp.nes.nec.co.jp
Cc: balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>, d-nishimura@mtf.biglobe.ne.jp
Subject: Re: [PATCH] memcg: fix stale swap cache leak v5
Message-Id: <20090502120919.0c86b53a.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20090502115649.027e4a88.d-nishimura@mtf.biglobe.ne.jp>
References: <20090430161627.0ccce565.kamezawa.hiroyu@jp.fujitsu.com>
	<20090430163539.7a882cef.kamezawa.hiroyu@jp.fujitsu.com>
	<20090430180426.25ae2fa6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090430094252.GG4430@balbir.in.ibm.com>
	<20090430184738.752858ea.kamezawa.hiroyu@jp.fujitsu.com>
	<20090430181246.GM4430@balbir.in.ibm.com>
	<20090501133317.9c372d38.d-nishimura@mtf.biglobe.ne.jp>
	<20090501183256.GD4686@balbir.in.ibm.com>
	<20090502115649.027e4a88.d-nishimura@mtf.biglobe.ne.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my small box(i386/2CPU/2GB mem), a similar test shows after 12H
> about 600MB leak of swap cache before applying this patch,
Oops, not 600MB but 600KB.

Sorry,
Daisuke Nishimura.
