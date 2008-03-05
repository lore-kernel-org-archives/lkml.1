Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbYCEBnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbYCEBnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbYCEBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:43:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52639 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYCEBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:43:04 -0500
Date: Wed, 05 Mar 2008 10:42:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1204643158.5338.5.camel@localhost>
References: <20080304192441.1EA2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1204643158.5338.5.camel@localhost>
Message-Id: <20080305103545.1EAE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +config NORECLAIM
> > > +	bool "Track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > > +	depends on EXPERIMENTAL && 64BIT
> > 
> > as far as I remembered, somebody said CONFIG_NORECLAIM is easy confusable.
> > may be..
> > 
> > IMHO insert "lru" word is better.
> > example,
> > 
> > config NORECLAIM_LRU
> > 	bool "Zone LRU of track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > 	depends on EXPERIMENTAL && 64BIT
> 
> OK.  But, I'd suggest the 'bool' description be something like:
> 
> config NORECLAIM_LRU
> 	bool "Add LRU list to track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"

That's nice. thanks.



