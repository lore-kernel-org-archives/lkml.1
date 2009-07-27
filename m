Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZG0WUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZG0WUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZG0WUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:20:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZG0WUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:20:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
Date: Tue, 28 Jul 2009 00:21:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280021.26320.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, David Rientjes wrote:
> On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> > Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2009-06-27 16:15 (30 days old)
> > References	: http://lkml.org/lkml/2009/6/27/75
> > 		  http://lkml.org/lkml/2009/7/7/6
> > 
> 
> This is fixed in mmotm with the following patches, waiting for Andrew's 
> push to Linus:
> 
> 	page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
> 	net-dccp-suppress-warning-about-large-allocations-from-dccp.patch

Thanks, updated.

Rafael
