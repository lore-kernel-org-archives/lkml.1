Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888Ab0AYCha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0AYCha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 21:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421Ab0AYCh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 21:37:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38369 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0AYCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 21:37:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "A. Boulan" <arnaud.boulan@libertysurf.fr>
Subject: Re: [Bug #14933] OOM killer unexpectedly called
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <q60Z28d_9yH.A.LQ.iZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.LQ.iZMXLB@chimera>
Message-Id: <20100125111948.493B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Jan 2010 11:37:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14933
> Subject		: OOM killer unexpectedly called
> Submitter	: A. Boulan <arnaud.boulan@libertysurf.fr>
> Date		: 2009-12-24 23:42 (32 days old)
> References	: http://marc.info/?l=linux-kernel&m=126169821317492&w=4

Boulan, Can you please help our debugging?
can you disable following config option at once?

1. CONFIG_DRM_I915
2. CONFIG_RELAY
3. CONFIG_MSPEC
4. VIDEOBUF_DMA_SG

I mean
  - if anyone return VM_FAULT_OOM, this issue occur.
  - very few subsys can return VM_FAULT_OOM in their own fault handler.
  - I hope investigate this is core mm issue or not.
    (unfortunatelly, I haven't find any dubious recent mm change..)


Thanks.



