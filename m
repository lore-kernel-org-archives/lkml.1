Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZKECbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZKECbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZKECbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:31:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59420 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZKECbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:31:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Nov 2009 11:28:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] show per-process swap usage via procfs
Message-Id: <20091105112844.b57e02f6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091105082357.54D3.A69D9226@jp.fujitsu.com>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
	<20091105082357.54D3.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Nov 2009 08:25:28 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:
> > 
> > > Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> > > RSS usage is important information but one more information which
> > > is often asked by users is "usage of swap".(user support team said.)
> > 
> > Hmmm... Could we do some rework of the counters first so that they are per
> > cpu?
> 
> per-cpu swap counter?
> It seems overkill effort....
> 
I nearly agree with you.

Thanks,
-Kame

