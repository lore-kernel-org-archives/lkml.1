Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbZKDXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbZKDXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbZKDXZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:25:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbZKDXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:25:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] show per-process swap usage via procfs
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
Message-Id: <20091105082357.54D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Nov 2009 08:25:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> > RSS usage is important information but one more information which
> > is often asked by users is "usage of swap".(user support team said.)
> 
> Hmmm... Could we do some rework of the counters first so that they are per
> cpu?

per-cpu swap counter?
It seems overkill effort....



