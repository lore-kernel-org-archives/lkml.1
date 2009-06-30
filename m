Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZF3OAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZF3OAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZF3OAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:00:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZF3OAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:00:02 -0400
Date: Tue, 30 Jun 2009 10:58:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rientjes@google.com, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, thomas@m3y3r.de, rjw@sisk.pl,
       dccp@vger.kernel.org
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
	__alloc_pages_nodemask
Message-ID: <20090630135851.GA12663@ghostprotocols.net>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.cBC.0IASKB@chimera> <alpine.DEB.2.00.0906291703430.17663@chino.kir.corp.google.com> <20090629.191655.193712233.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629.191655.193712233.davem@davemloft.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 29, 2009 at 07:16:55PM -0700, David Miller escreveu:
> From: David Rientjes <rientjes@google.com>
> Date: Mon, 29 Jun 2009 17:06:42 -0700 (PDT)
> 
> > On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> > 
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >> 
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.30.  Please verify if it still should be listed and let me know
> >> (either way).
> >> 
> >> 
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> >> Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> >> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> >> Date		: 2009-06-27 16:15 (2 days old)
> >> References	: http://lkml.org/lkml/2009/6/27/75
> >> 
> > 
> > dccp_init() is trying to allocate a goal that causes the order in 
> > __get_free_pages() to be >= MAX_ORDER.  
> > 
> > Arnaldo, can we cap ehash_order and bhash_order at MAX_ORDER - 1?
> 
> There was a patch going arond for this already.

http://patchwork.kernel.org/patch/31784/

- Arnaldo
