Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZGIFOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZGIFOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZGIFNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:13:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38637 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZGIFNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:13:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20090707135656.GB9444@localhost>
References: <20090707102106.0C66.A69D9226@jp.fujitsu.com> <20090707135656.GB9444@localhost>
Message-Id: <20090709141319.23A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 14:13:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 07, 2009 at 09:22:48AM +0800, KOSAKI Motohiro wrote:
> > > On Sun, Jul 05, 2009 at 08:21:20PM +0800, KOSAKI Motohiro wrote:
> > > > > On Sun, Jul 05, 2009 at 05:26:18PM +0800, KOSAKI Motohiro wrote:
> 
> > @@ -2118,9 +2118,9 @@ void show_free_areas(void)
> >  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> >  		" inactive_file:%lu unevictable:%lu\n"
> >  		" isolated_anon:%lu isolated_file:%lu\n"
> > -		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
> > +		" dirty:%lu writeback:%lu buffer:%lu shmem:%lu\n"
> 
> btw, nfs unstable pages are related to writeback pages, so it may be
> better to put "unstable" right after "writeback" (as it was)?

OK, will fix.



