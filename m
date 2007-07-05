Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXGEJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXGEJDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbXGEJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:03:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:48883 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753638AbXGEJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:03:29 -0400
Subject: Re: [PATCH] debug workqueue flushing deadlocks with lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183577668.9662.11.camel@johannes.berg>
References: <1183577668.9662.11.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:03:21 +0200
Message-Id: <1183626201.7054.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 21:34 +0200, Johannes Berg wrote:
> This patch adds a fake lock to each workqueue in order to debug things
> where you have something like
> 
>   my_function() -> lock(); ...; flush_workqueue(); ...
> vs
>   run_workqueue() -> my_work() -> ...; lock(); ...
> 
> which can obviously deadlock if my_work is scheduled when my_function()
> is invoked (but hasn't locked yet.)
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

