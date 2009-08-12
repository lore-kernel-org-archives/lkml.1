Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZHLSGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZHLSGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZHLSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:06:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33425
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZHLSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:06:36 -0400
Date: Wed, 12 Aug 2009 11:06:46 -0700 (PDT)
Message-Id: <20090812.110646.239052896.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       mingo@elte.hu
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090806070242.GF12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk>
	<20090802.131705.81498579.davem@davemloft.net>
	<20090806070242.GF12579@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 6 Aug 2009 09:02:42 +0200

> On Sun, Aug 02 2009, David Miller wrote:
>> From: Jens Axboe <jens.axboe@oracle.com>
>> Date: Wed, 29 Jul 2009 13:25:10 +0200
>> 
>> > -#define NR_SYSCALLS		327
>> > +#define NR_SYSCALLS		328
>> 
>> When you increase this value, you have to add entries to all of the
>> syscall tables.  The syscall dispatch checks against this as a limit,
>> so if you don't explicitly add an entry to all the tables, it's
>> possible to deref garbage past the end of the table and try to jump to
>> it as a syscall.
> 
> Oops, missed the 32-bit table. Does the below look better?

I'll take a look at this as soon as I can Jens, sorry for taking
so long.
