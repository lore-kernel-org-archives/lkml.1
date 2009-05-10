Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZEJX7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZEJX7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZEJX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:59:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58122 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZEJX7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:59:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
Message-Id: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 08:59:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.

This is intensional behavior. plus you change very widely caller bahavior.
if you don't have good test program, I nak this.


> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>


