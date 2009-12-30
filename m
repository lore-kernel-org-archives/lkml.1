Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZL3AuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZL3AuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL3AuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:50:14 -0500
Received: from sh.osrg.net ([192.16.179.4]:52355 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZL3AuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:50:13 -0500
Date: Wed, 30 Dec 2009 09:48:47 +0900
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, rdreier@cisco.com,
       yinghai@kernel.org
Subject: Re: [Bug #14901] bisected crash due to "x86: Move swiotlb
 initialization before dma32_free_bootmem"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <NJVdobuNFNK.A.A9H.cnhOLB@chimera>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	<NJVdobuNFNK.A.A9H.cnhOLB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091230094819K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Dec 2009 09:48:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009 16:09:58 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14901
> Subject		: bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
> Submitter	: Roland Dreier <rdreier@cisco.com>
> Date		: 2009-12-15 7:47 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=126086324302061&w=4
> Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 		  Yinghai Lu <yinghai@kernel.org>

Already fixed by the commit 186a25026c44d1bfa97671110ff14dcd0c99678e.

Thanks,
