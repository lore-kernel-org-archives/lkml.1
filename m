Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXD2Pyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXD2Pyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXD2Pyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:54:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:42186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbXD2Pyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:54:39 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Date: Sun, 29 Apr 2007 11:53:10 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Miles Lane" <miles.lane@gmail.com>,
       lollul@wp.pl, Matt Mackall <mpm@selenic.com>,
       Helge Hafting <helgehaf@aitel.hist.no>
References: <200704290102.33533.lenb@kernel.org> <20070429010104.68c51d1a.akpm@linux-foundation.org>
In-Reply-To: <20070429010104.68c51d1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291153.10451.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 04:01, Andrew Morton wrote:
> On Sun, 29 Apr 2007 01:02:33 -0400 Len Brown <lenb@kernel.org> wrote:
> 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > 
> > This batch mostly updates the platform-specific drivers that use ACPI.
> > The EC and sbs changes are primarily cleanups.
> > There are no changes to the ACPICA core, except a single bugfix
> > that was related to a 2.6.21 boot regression on some older machines.
> > And then the usual mix of random tweaks.
> 
> There might still be a few regressions in this lot:
> 
> - Miles Lane's "2.6.21-rc7-mm2 -- gnome-power-manager always shows the
>   power as coming from AC"
> 
> - "battery caching introduces a lock up"
>   http://bugzilla.kernel.org/show_bug.cgi?id=8351

This git pull request does not include the proposed changes to the battery.

cheers,
-Len

> These are older and might have been fixed:
> 
> - Mat Mackall's "Thinkpads not waking up on lid open with -rc6-mm1"
> 
> - Helge Hafting's "2.6.21-rc3-mm2 hangs my opteron during bootup, ACPI?"
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
