Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXGEJDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXGEJDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbXGEJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:03:36 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65321 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759339AbXGEJDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:03:35 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183583529.9662.34.camel@johannes.berg>
References: <1183583529.9662.34.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:03:24 +0200
Message-Id: <1183626204.7054.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 23:12 +0200, Johannes Berg wrote:
> This adds a lockdep_map for each work struct in order to debug
> deadlocks like
>   my_function -> lock(); ...; cancel_work_sync(my_work)
> vs.
>   run_workqueue() -> my_work.f() -> ...; lock(); ...
> 
> which will deadlock if my_work.f() is invoked already but my_function()
> has acquired the lock already.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

