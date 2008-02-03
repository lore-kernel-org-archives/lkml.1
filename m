Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYBCVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYBCVDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYBCVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:03:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYBCVDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:03:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] x86 PM: Consolidate suspend and hibernation code
Date: Sun, 3 Feb 2008 21:41:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802032141.56887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches consolidates the x86 suspend and hibernation code.
It does the following:
- move 64-bit hibernation/suspend files to arch/x86/power (under different
  names)
- rename 32-bit files in arch/x86/power in line with the 64-bit files
- separate hibernation-specific 64-bit code from the code used for both
  suspend and hibernation and simplify the Makefile
- fix up comments
Details are in the changelogs.

These patches don't introduce any functional changes.

Please review (and consider for merging if they look good :-)).

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

