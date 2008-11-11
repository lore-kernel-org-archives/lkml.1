Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKKI62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKKI62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYKKI6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:58:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46080 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYKKI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:58:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Pan ruochen" <panruochen@gmail.com>
Subject: Re: How kernel applies LRU to swap out physical pages?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
References: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
Message-Id: <20081111175417.8B35.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 17:58:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi All,
> I'm reading the linux kernel 2.6.14. 

it seems too old.
I recommend to read newest kernel.

> But can't understand how LRU algorithm
> is applied to page swapping. what is the 'USED' of LRU referred to? The
> reference counter which the page is mapped by processes, or the frequency that
> CPU reads/writes in the page. In common sense, the LRU algorithm will be more
> optimal for the second case. But it depends on CPU capability.
> I will be very appreciated if somebody can explain that in details.

I recommend to read page_referenced() and its related function :)



