Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYKKLdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYKKLdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYKKLdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:33:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbYKKLdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:33:44 -0500
Subject: Re: How kernel applies LRU to swap out physical pages?
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pan ruochen <panruochen@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081111180233.8B38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
	 <1226393845.7685.1294.camel@twins>
	 <20081111180233.8B38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2008 12:33:40 +0100
Message-Id: <1226403220.7685.1601.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 18:56 +0900, KOSAKI Motohiro wrote:
> > On Tue, 2008-11-11 at 16:22 +0800, Pan ruochen wrote:
> > > Hi All,
> > > I'm reading the linux kernel 2.6.14. But can't understand how LRU algorithm
> > > is applied to page swapping. what is the 'USED' of LRU referred to? The
> > > reference counter which the page is mapped by processes, or the frequency that
> > > CPU reads/writes in the page. In common sense, the LRU algorithm will be more
> > > optimal for the second case. But it depends on CPU capability.
> > > I will be very appreciated if somebody can explain that in details.
> > 
> > We don't actually use LRU but something like CLOCK.

FWIW in case you hadn't found it yet:

 http://en.wikipedia.org/wiki/Page_replacement_algorithm

is a fairly decent page on the subject.
