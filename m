Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXD2ICl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXD2ICl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXD2ICl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:02:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659AbXD2ICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:02:38 -0400
Date: Sun, 29 Apr 2007 01:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Miles Lane" <miles.lane@gmail.com>,
       lollul@wp.pl, Matt Mackall <mpm@selenic.com>,
       Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Message-Id: <20070429010104.68c51d1a.akpm@linux-foundation.org>
In-Reply-To: <200704290102.33533.lenb@kernel.org>
References: <200704290102.33533.lenb@kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 01:02:33 -0400 Len Brown <lenb@kernel.org> wrote:

> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> This batch mostly updates the platform-specific drivers that use ACPI.
> The EC and sbs changes are primarily cleanups.
> There are no changes to the ACPICA core, except a single bugfix
> that was related to a 2.6.21 boot regression on some older machines.
> And then the usual mix of random tweaks.

There might still be a few regressions in this lot:

- Miles Lane's "2.6.21-rc7-mm2 -- gnome-power-manager always shows the
  power as coming from AC"

- "battery caching introduces a lock up"
  http://bugzilla.kernel.org/show_bug.cgi?id=8351

These are older and might have been fixed:

- Mat Mackall's "Thinkpads not waking up on lid open with -rc6-mm1"

- Helge Hafting's "2.6.21-rc3-mm2 hangs my opteron during bootup, ACPI?"

