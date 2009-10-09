Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbZJIHgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbZJIHgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZJIHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:36:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbZJIHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:36:00 -0400
Date: Fri, 9 Oct 2009 00:35:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: kmalloc failure ignored in init_std_data()
Message-Id: <20091009003507.35f617d7.akpm@linux-foundation.org>
In-Reply-To: <4AB42BAF.90204@gmail.com>
References: <4AB411D9.6070702@gmail.com>
	<1253319020.3364.180.camel@calx>
	<4AB42BAF.90204@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009 02:54:07 +0200 Roel Kluin <roel.kluin@gmail.com> wrote:

> kmalloc may fail so build the array into the statically allocated
> pool structures instead.

x86_64 allnoconfig:

drivers/char/random.c: In function 'extract_entropy':
drivers/char/random.c:867: error: 'struct entropy_store' has no member named 'last_data'
drivers/char/random.c:869: error: 'struct entropy_store' has no member named 'last_data'
drivers/char/random.c:871: error: 'struct entropy_store' has no member named 'last_data'
drivers/char/random.c:871: error: 'struct entropy_store' has no member named 'last_data'

