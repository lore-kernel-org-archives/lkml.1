Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZGGEXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZGGEXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZGGEXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:23:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZGGEXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:23:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=U1PBUxLtciu80z+AL58IJ7X5aWw3VvJ/NKLyeA958XLgGwKbbNbbt93qLA0PNvp3z
	MYjb3DY7UnYGYireOOvKQ==
Date: Mon, 6 Jul 2009 21:23:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Meyer <thomas@m3y3r.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
In-Reply-To: <dWkuWjWDsSB.A.iyE.f0oUKB@chimera>
Message-ID: <alpine.DEB.2.00.0907062101330.31794@chino.kir.corp.google.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.iyE.f0oUKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2009-06-27 16:15 (10 days old)
> References	: http://lkml.org/lkml/2009/6/27/75
> 

This should be suppressed with the patchset proposed by Mel on linux-mm:

	http://marc.info/?l=linux-mm&m=124568542405734
	http://marc.info/?l=linux-mm&m=124568542605738
	http://marc.info/?l=linux-mm&m=124568542905750
	http://marc.info/?l=linux-mm&m=124568543305755

It doesn't appear that these are in linux-next, however.
