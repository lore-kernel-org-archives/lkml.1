Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYDJE2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYDJE2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 00:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYDJE2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 00:28:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37413 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYDJE2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 00:28:14 -0400
Date: Thu, 10 Apr 2008 13:26:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 09/17] Add all cpus option to stop machine run
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jason Baron <jbaron@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
In-Reply-To: <20080409182454.GF30885@one.firstfloor.org>
References: <20080409181010.GA4924@martell.zuzino.mipt.ru> <20080409182454.GF30885@one.firstfloor.org>
Message-Id: <20080410132412.231F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and will never be measured on real life workloads. Right now you
> > claim 1 (one) cacheline saving in schedule() which can be trivially
> 
> That is just an example. Once the infrastructure is in a lot more
> flags would move it into it. I think eventually most sysctls
> should be immediate values for once.

It seems very good viewpoint.
if sysctl value become immediate, I think some fastpath increase performance.


