Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZHCVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZHCVDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZHCVD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:03:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbZHCVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:03:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [Regression] Hibernation failure on dual core Athlon 64 (64-bit)
Date: Mon, 3 Aug 2009 23:03:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032303.57859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

As reported at

http://bugzilla.kernel.org/show_bug.cgi?id=13903

one of my test systems suffers from a hibernation regression where the second
attempt to hibernate in a row makes it hang solid right before creating the
image.

Bisection turned up your commit 3f4a782b5ce2698b1870b5a7b573cd721d4fce33
([CPUFREQ] fix (utter) cpufreq_add_dev mess) as the first bad one.

Best,
Rafael
