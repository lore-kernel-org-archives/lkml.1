Return-Path: <linux-kernel-owner+w=401wt.eu-S1763611AbYBFCAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763611AbYBFCAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbYBFCAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:00:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51983 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477AbYBFCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:00:00 -0500
Date: Wed, 06 Feb 2008 10:54:11 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] badness() dramatically overcounts memory
Cc: kosaki.motohiro@jp.fujitsu.com, Jeff Davis <linux@j-davis.com>,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@qumranet.com>
In-Reply-To: <alpine.DEB.1.00.0802051507460.18347@chino.kir.corp.google.com>
References: <1202252561.24634.64.camel@dogma.ljc.laika.com> <alpine.DEB.1.00.0802051507460.18347@chino.kir.corp.google.com>
Message-Id: <20080206105041.2717.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > The interesting thing is the use of total_vm and not the RSS which is used as
> > > the basis by the OOM killer. I need to read/understand the code a bit more.
> > 
> > RSS makes more sense to me as well.
> 
> Andrea Arcangeli has patches pending which change this to the RSS.  
> Specifically:
> 
> 	http://marc.info/?l=linux-mm&m=119977937126925

I agreed with you that RSS is better :)



but..
on many node numa, per zone rss is more better..


- kosaki


