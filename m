Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYBJRYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYBJRYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYBJRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:23:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:35657 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750893AbYBJRXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:23:52 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18BISZJvTkB+cFlTGcorasobk3Qwqo+K5mHFZq8qa
	xHyeuLq0y3Rf8B
Subject: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 18:21:49 +0100
Message-Id: <1202664109.8394.19.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I think I found a regression in 2.6.24-git. After waking up from suspend
2 ram, the fan of my laptop turns constantly at highest speed. It didn't
do this in 2.6.24.

I bisected it down to this commit:

commit c95d47a868f35cd47643d116a3c680cdaa954df8
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 8 00:05:21 2008 +0100

    ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK

Reverting it resolves the problem for me, but I can't say if this makes
any sense.

My machine is a Zepto laptop with Intel Santa-Rosa chipset and I'm
running
a x86_64 Ubuntu Gutsy.

Mirco




