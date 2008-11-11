Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYKKJ5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYKKJ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYKKJ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:56:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48565 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYKKJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:56:58 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: How kernel applies LRU to swap out physical pages?
Cc: kosaki.motohiro@jp.fujitsu.com, Pan ruochen <panruochen@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226393845.7685.1294.camel@twins>
References: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com> <1226393845.7685.1294.camel@twins>
Message-Id: <20081111180233.8B38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 18:56:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-11-11 at 16:22 +0800, Pan ruochen wrote:
> > Hi All,
> > I'm reading the linux kernel 2.6.14. But can't understand how LRU algorithm
> > is applied to page swapping. what is the 'USED' of LRU referred to? The
> > reference counter which the page is mapped by processes, or the frequency that
> > CPU reads/writes in the page. In common sense, the LRU algorithm will be more
> > optimal for the second case. But it depends on CPU capability.
> > I will be very appreciated if somebody can explain that in details.
> 
> We don't actually use LRU but something like CLOCK.

Yup.

However, VM replace algorithm folks commonly call it to "LRU"
because MACH call so.

IOW, it is historical reason word, shouldn't imazine strict 
"Least Recently Used" algorithm.



