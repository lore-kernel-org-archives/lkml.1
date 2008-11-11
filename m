Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYKKI5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYKKI5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYKKI52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:57:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:52508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbYKKI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:57:28 -0500
Subject: Re: How kernel applies LRU to swap out physical pages?
From: Peter Zijlstra <peterz@infradead.org>
To: Pan ruochen <panruochen@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
References: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2008 09:57:25 +0100
Message-Id: <1226393845.7685.1294.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 16:22 +0800, Pan ruochen wrote:
> Hi All,
> I'm reading the linux kernel 2.6.14. But can't understand how LRU algorithm
> is applied to page swapping. what is the 'USED' of LRU referred to? The
> reference counter which the page is mapped by processes, or the frequency that
> CPU reads/writes in the page. In common sense, the LRU algorithm will be more
> optimal for the second case. But it depends on CPU capability.
> I will be very appreciated if somebody can explain that in details.

We don't actually use LRU but something like CLOCK.
