Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbYCMGqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYCMGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYCMGqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:46:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYCMGqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:46:01 -0400
Date: Wed, 12 Mar 2008 23:45:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Message-Id: <20080312234516.bb079cc5.akpm@linux-foundation.org>
In-Reply-To: <200803130214.36861.lenb@kernel.org>
References: <200803130214.36861.lenb@kernel.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 02:14:36 -0400 Len Brown <lenb@kernel.org> wrote:

> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> A bunch of small regression fixes, bug fixes, and a couple of minor cleanups.

I hope Rafael knows how to cross-reference the regression fixes against his list?



I'm sitting on five ACPI patches which look like they (or alternatives?) should
be in 2.6.25:


http://userweb.kernel.org/~akpm/mmotm/broken-out/acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch

  This was too poorly changelogged for me to remember what problem it
  solves, but it seemed important at the time.

http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch

  Fix logic error in asus_acpi.c

http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch

  Fix an overrun.

http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch

  Hopeully fix a regression which Andrea Arcangeli hit.  Although I'm not sure
  that he has confirmed that this revert actually works?

http://userweb.kernel.org/~akpm/mmotm/broken-out/acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch

  Fix a system lockup related to undocking.


