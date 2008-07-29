Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYG2NFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYG2NFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2NEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:04:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43481 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYG2NEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:04:55 -0400
Date: Tue, 29 Jul 2008 22:04:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
In-Reply-To: <20080724222510.3bbbbedc@bree.surriel.com>
References: <20080724222510.3bbbbedc@bree.surriel.com>
Message-Id: <20080729220012.F192.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   TEST 1: dd if=/dev/sda of=/dev/null bs=1M
> 
> kernel  speed    swap used
> 
> 2.6.26  111MB/s  500kB
> -mm     110MB/s  59MB     (ouch, system noticably slower)
> noforce	111MB/s  128kB
> stream  108MB/s  0        (slight regression, not sure why yet)

I tried to reproduce it, my ia64 result was

kernel                   speed        swap used
2.6.26-rc8               49.8MB/s     1M
2.6.26-rc8-mm1           47.6MB/s     168M
-mm with above two patch 50.2MB/s     0


So, I think it isn't regression.



