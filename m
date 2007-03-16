Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXCPIuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXCPIuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXCPIuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:50:08 -0400
Received: from main.gmane.org ([80.91.229.2]:34660 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXCPIuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:50:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: 2.6.21-rc3: suspend broken on Thinkpad R60
Date: Fri, 16 Mar 2007 09:40:58 +0100
Message-ID: <etdl6q$ef6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 67.152.216.81.static.g-va.siw.siwnet.net
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

suspend (to RAM and disk) broke on my Thinkpad R60 (Core 2 Duo laptop)
somewhere between 2.6.20 and 2.6.21-rc3 (commit
8ce5e3e45e01ffab38a9f03900181132b9068543), but most likely before -rc2. In
contrast to previous reports I saw on the list, it actually hangs at
suspend, not resume.

On suspend to RAM (either through s2ram or through /sys/power/state) it
hangs after the message "Suspending consoles" with the sleep LED flashing.
Suspend to disk hangs similarly after "Snapshotting system".

Is this a known issue? Should I git-bisect it? I'm running Debian with a
custom-compiled x86_64 SMP kernel.

Marcus


