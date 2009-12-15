Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZLOAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZLOAL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZLOAL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:11:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbZLOALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:11:55 -0500
Date: Mon, 14 Dec 2009 16:11:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912141609020.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912141610460.14385@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912142311.31658.rjw@sisk.pl> <alpine.LFD.2.00.0912141416040.26135@localhost.localdomain> <200912150018.11837.rjw@sisk.pl>
 <alpine.LFD.2.00.0912141609020.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Linus Torvalds wrote:
> 
> I get really tired of this whole stupid async discussion, because you're 
> overdesigning it.

Btw, this is important. I'm not going to pull even your _current_ async 
stuff if you can't show that you fundamentally UNDERSTAND this fact.

Stop making up idiotic complex interfaces. Look at my one-liner patch, and 
realize that it gets you 99% there - the 99% that matters.

		Linus
