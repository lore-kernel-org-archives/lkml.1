Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXCUXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXCUXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXCUXCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:02:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22537 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXCUXCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:02:45 -0400
Date: Wed, 21 Mar 2007 16:01:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
Message-Id: <20070321160132.983812ac.randy.dunlap@oracle.com>
In-Reply-To: <45FF6189.9080508@zytor.com>
References: <20061214223718.GA3816@elf.ucw.cz>
	<20061216094421.416a271e.randy.dunlap@oracle.com>
	<20061216095702.3e6f1d1f.akpm@osdl.org>
	<458434B0.4090506@oracle.com>
	<1166297434.26330.34.camel@localhost.localdomain>
	<20061219063413.GI24090@1wt.eu>
	<1166511171.26330.120.camel@localhost.localdomain>
	<20070106103331.48150aed.randy.dunlap@oracle.com>
	<459FF60D.7080901@zytor.com>
	<1168112266.2821.2.camel@entropy>
	<20070106121301.d07de0c9.akpm@osdl.org>
	<45A0041F.4060903@zytor.com>
	<20070319122740.286f602e.randy.dunlap@oracle.com>
	<20070319133613.9f4881db.akpm@linux-foundation.org>
	<45FEF5BC.90809@oracle.com>
	<45FF6189.9080508@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 21:22:33 -0700 H. Peter Anvin wrote:

> Randy Dunlap wrote:
> >>
> >> The we duplicate all the relevant /proc knobs:
> >>
> >> cat /proc/sys/vm/dirty_ratio
> >> 30
> >> cat /proc/sys/vm/hires-dirty_ratio/
> >> 300000
> >>
> >> Or we do something else ;)
> > 
> > Sounds better.  I wasn't very keen on the userspace interface that this
> > exposed.  Will look at those.
> > 
> 
> Okay... may be I could throw a spanner in the machinery, and suggest 
> another option: perhaps we should add a way to do sysctl which can 
> handle fractional (fixed-point) values... more coherent/detailed message 
> tomorrow.

I prefer the fixed-point values for pressure and dirty* to having
duplicated entries for each of them.  I'll proceed with that idea.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
