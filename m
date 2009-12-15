Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZLOAKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZLOAKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZLOAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:10:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758276AbZLOAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:10:20 -0500
Date: Mon, 14 Dec 2009 16:10:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912150018.11837.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912141609020.14385@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912142311.31658.rjw@sisk.pl> <alpine.LFD.2.00.0912141416040.26135@localhost.localdomain> <200912150018.11837.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Dec 2009, Rafael J. Wysocki wrote:
> 
> Because the PCI bridges are not the only case where it matters (I'd say they
> are really a corner case).  Basically, any two async devices separeted by a
> series of sync ones are likely not to be suspended (or resumed) in parallel
> with each other, because the parent is usually next to its children in dpm_list.

Give a real example that matters.

Really. 

How hard can it be to understand: KISS. Keep It Simple, Stupid.

I get really tired of this whole stupid async discussion, because you're 
overdesigning it.

To a first approximation, THE ONLY THING THAT MATTERS IS USB.

		Linus
