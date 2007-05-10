Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbXEJOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbXEJOUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbXEJOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:20:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37703 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbXEJOUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:20:21 -0400
Date: Thu, 10 May 2007 16:17:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705101616361.32349@yvahk01.tjqt.qr>
References: <20070508194845.GC24114@agk.fab.redhat.com>
 <20070508174159.7d78a275.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 17:41, Andrew Morton wrote:
>On Tue, 8 May 2007 20:48:45 +0100
>Alasdair G Kergon <agk@redhat.com> wrote:
>
>> +#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
>> +
>> +#define BIO_LIST(bl) \
>> +	struct bio_list bl = BIO_LIST_INIT
>
>BIO_LIST is a strange name for something which initialises storage.

So try DEFINE_BIO_LIST, it goes in line with DEFINE_SPINLOCK for example.


	Jan
-- 
