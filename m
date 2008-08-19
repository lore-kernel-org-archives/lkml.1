Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYHSWx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYHSWx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYHSWxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:15 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:12342 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYHSWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:14 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 0/8] PNP debugging rework
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:10 -0600
Message-ID: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for a boot-time switch to enable PNP debug
messages.  Currently, users have to recompile with CONFIG_PNP_DEBUG=y
to get PNP debug messages.

I copied the implementation strategy from Greg KH's USB patches:
    http://lkml.org/lkml/2008/8/8/529

These patches don't fix any bugs, and I know it's pretty late to
consider new stuff for 2.6.27.  The only reason to even consider them
is that 2.6.27 includes a significant PNP rewrite, and if 2.6.27 ends
up in a distro kernel, it will be much easier to work on problems if
users can collect debug information without rebuilding the kernel.

Bjorn
