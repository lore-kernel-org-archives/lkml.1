Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbZKERyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbZKERyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbZKERyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:54:35 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:47184 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757529AbZKERyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:54:35 -0500
Date: Thu, 5 Nov 2009 10:04:01 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] show per-process swap usage via procfs
In-Reply-To: <20091105082357.54D3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911051003060.25718@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1> <20091105082357.54D3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, KOSAKI Motohiro wrote:

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

The other alternative is to use atomic ops which are significantly slower
and have an impact on critical sections.

