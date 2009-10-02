Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZJBVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZJBVXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZJBVXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:23:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZJBVXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:23:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [Bug #13942] Troubles with AoE and uninitialized object
Date: Fri, 2 Oct 2009 23:24:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.t9C.XOTxKB@chimera> <20091002213630.42c73909@neptune.home>
In-Reply-To: <20091002213630.42c73909@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910022324.37790.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Bruno Prémont wrote:
> On Thu, 01 October 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> > Subject	: Troubles with AoE and uninitialized object
> > Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> > Date		: 2009-08-04 10:12 (59 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4
> 
> This should have been fixed with commits:
> 
>   18d8217bc441630c3c5ec7416c5a65c69e8a0979
>   aoe: end barrier bios with EOPNOTSUPP
> 
>   This addresses the trace on unmounting XFS
> 
> 
>   7135a71b19be1faf48b7148d77844d03bc0717d6
>   aoe: allocate unused request_queue for sysfs
> 
>   This addresses the NULL kobject part
> 
> 
> I think the second one made it into 2.6.31 but first one didn't,

Yes, it idid.

> please double-check! I've not seen them on stable though (which might
> be worth especially for the first one)

Thanks, closed.

Rafael
