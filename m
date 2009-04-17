Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbZDQAtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbZDQAtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbZDQArS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:47:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761275AbZDQArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:47:14 -0400
Date: Thu, 16 Apr 2009 17:40:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Message-ID: <alpine.LFD.2.00.0904161738030.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I think you put this in the wrong regression pile:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
> Subject		: Oops in drain_array
> Submitter	: Bart <mmx@riz.pl>
> Date		: 2009-04-14 10:21 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4

Hmm. This one seems like it should be in the "since 2.6.28" camp, since if 
I read that one right, it happens with 2.6.29.1.

(I mean sure, it might be new since 2.6.29, but it sounds more likely that 
it's already in 2.6.29)

		Linus
