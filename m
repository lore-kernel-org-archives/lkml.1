Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYDBHVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYDBHVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYDBHU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:20:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32914 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYDBHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:20:57 -0400
Date: Wed, 2 Apr 2008 10:20:55 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
In-Reply-To: <20080402071709.GC12774@kernel.dk>
Message-ID: <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Jens Axboe wrote:
> Good catch, I wonder why it didn't complain in my testing. I've added a
> patch to fix that, please see it here:

You probably don't have kmemcheck in your kernel ;-)
