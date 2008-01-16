Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYAPMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYAPMGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYAPMFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:05:52 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:40050 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYAPMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:05:51 -0500
Date: Wed, 16 Jan 2008 17:35:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrea Righi <righiandr@users.sourceforge.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH]
	per-task I/O throttling)
Message-ID: <20080116120533.GB7166@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Valdis.Kletnieks@vt.edu,
	Andrea Righi <righiandr@users.sourceforge.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>
References: <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net> <20080116104541.GB25724@balbir.in.ibm.com> <13594.1200483031@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <13594.1200483031@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> [2008-01-16 06:30:31]:

> On Wed, 16 Jan 2008 16:15:41 +0530, Balbir Singh said:
> 
> > Thanks for doing this. I am going to review the patches in greater
> > detail and also test them. Why do you use configfs when we have a
> > control group filesystem available for grouping tasks and providing a
> > file system based interface for control and accounting?
> 
> And here I thought "There's more than one way to do it" was the Perl slogan. :)
>

Yes, there are several ways to do it, but the discussion over the last
year or so has been centered around control groups. We've discussed
all approaches on lkml on there was consensus on using control groups.
Please read the lkml archives for the discussion details.

 
> An equally valid question would be: "Why are we carrying around a control
> group filesystem when we have configfs?"  (Honestly, I didn't know we *were*
> carrying around such a filesystem - and quite likely Andrea Righi didn't
> either...)

Control groups is derived from cpusets and for those interested in
grouping tasks for control, is the preferred method of providing
control.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
