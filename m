Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZBWAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZBWAG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZBWAGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:06:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbZBWAGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:06:18 -0500
Date: Sun, 22 Feb 2009 16:05:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <200902230048.33635.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902221603440.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain> <200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Feb 2009, Rafael J. Wysocki wrote:
> 
> The updated patch is appended.

Ok, looks sane to me. I'll try it on my poor eeepc, although right now 
Fedora-11 rawhide (that poor laptop gets _all_ the crazy stuff thrown at 
it, and runs btrfs to boot) has broken something in X by enabling DRI2, so 
I may not get around to it today.

		Linus
