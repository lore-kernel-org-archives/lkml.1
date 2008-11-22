Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYKVXxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYKVXxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYKVXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:53:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38081 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbYKVXxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:53:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Regression: ACPI AC driver doesn't work on Toshiba Portege R500
Date: Sun, 23 Nov 2008 00:53:13 +0100
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811230053.14211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With current mainline (2.6.28-rc6-git1 as of today) on Toshiba Portege R500 the
status of the AC adapter is not updated when the adapter is unplugged and
plugged in.  Evidently, /sys/class/power_supply/ADP1/online always contains the
same value.  Interestingly enough, though, if the box is suspended to RAM and
resumed, the status of the AC adapter is correctly updated, but the value read
at that time remains in /sys/class/power_supply/ADP1/online until the next
suspend/resume cycle regardless of what's going on with the AC adapter.

2.6.27.7 works correctly on this box so the recent EC patches don't seem to
cause this regression to happen.

Any other ideas?

Rafael
