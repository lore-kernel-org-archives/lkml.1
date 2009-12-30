Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbZL3VnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbZL3VnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZL3VnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:43:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZL3VnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:43:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug #14901] bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
Date: Wed, 30 Dec 2009 22:43:50 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       mingo@elte.hu, rdreier@cisco.com, yinghai@kernel.org
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.A9H.cnhOLB@chimera> <20091230094819K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091230094819K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302243.50182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, FUJITA Tomonori wrote:
> On Tue, 29 Dec 2009 16:09:58 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14901
> > Subject		: bisected crash due to "x86: Move swiotlb initialization before dma32_free_bootmem"
> > Submitter	: Roland Dreier <rdreier@cisco.com>
> > Date		: 2009-12-15 7:47 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126086324302061&w=4
> > Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 		  Yinghai Lu <yinghai@kernel.org>
> 
> Already fixed by the commit 186a25026c44d1bfa97671110ff14dcd0c99678e.

Thanks, closed.

Rafael
