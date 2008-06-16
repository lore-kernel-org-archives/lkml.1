Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYFPGUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYFPGUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYFPGUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:20:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbYFPGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:20:36 -0400
Date: Sun, 15 Jun 2008 23:20:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH -mm 00/24] VM pageout scalability improvements (V12)
Message-Id: <20080615232011.64925446.akpm@linux-foundation.org>
In-Reply-To: <20080616143034.78A1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080611184214.605110868@redhat.com>
	<20080611223430.cba0f1b6.akpm@linux-foundation.org>
	<20080616143034.78A1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 14:32:33 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > qsbench, 4 processes, memory size tuned to threshold-of-swapping*1.1:
> > 
> > Mainline:
> > 
> > vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> > ./qsbench -p 4 -m 230  175.45s user 45.67s system 60% cpu 6:08.40 total
> > 
> > 2.6.26-rc5-mm3:
> > 
> > vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> > ./qsbench -p 4 -m 230  178.21s user 28.49s system 99% cpu 3:27.14 total
> 
> Where can I get this benchmark?
> 

http://userweb.kernel.org/~akpm/qsbench.tar.gz

> I guess it is too old ;)

I might have added it - I forget.

