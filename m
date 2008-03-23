Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYCWAf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYCWAf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 20:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYCWAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 20:35:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbYCWAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 20:35:10 -0400
Date: Sat, 22 Mar 2008 17:35:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Message-Id: <20080322173500.7b8b6751.akpm@linux-foundation.org>
In-Reply-To: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 13:24:54 -0700 David Brownell <david-b@pacbell.net> wrote:

> I noticed this with 2.6.25-rc2 (if not before), and the problem
> is still there with 2.6.25-rc6-git (as of this AM).
> 
> System is an Athlon64 single CPU laptop, and instead of reading a
> few dozen wakeups per second, it says a many tens of thousands...
> clearly wrong.  In previous kernels it gave more plausible counts;
> unfortunately high because of various un-evolved desktop tools in
> this Ubuntu system (Feisty).
> 
> Possibly more truthful, it says that the system never enters
> C1 or C2, and spends all its time in C0.  Though if I look at
> /sys/devices/system/cpu/cpu0/cpuidle/state[01]/usage, that
> seems to tell a different story ... it's C0 that's never used.
> In previous kernels it reported time in both C0 and C2.  ISTR
> some patch to avoid C2, which would explain part of this.
> 
> Comments or fixes, anyone?

This is likely to be an acpi regression, isn't it?

A git-bisect would be nice, please.
