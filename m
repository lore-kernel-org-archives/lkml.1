Return-Path: <linux-kernel-owner+w=401wt.eu-S1161223AbXDQUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223AbXDQUH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDQUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:07:28 -0400
Received: from waste.org ([66.93.16.53]:56193 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161039AbXDQUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:07:27 -0400
Date: Tue, 17 Apr 2007 14:55:00 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Thinkpads not waking up on lid open with -rc6-mm1
Message-ID: <20070417195459.GJ11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both my T30 and R51 aren't waking up when I open the lid any more. I
have to hold down the power button for a moment. On my R51, I see this:

$ cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
LID       S3    *enabled
SLPB      S3    *enabled
PCI0      S3     disabled  no-bus:pci0000:00
UART      S3     disabled  pnp:00:09
PCI1      S4     disabled  pci:0000:00:1e.0
USB0      S3     disabled  pci:0000:00:1d.0
USB1      S3     disabled  pci:0000:00:1d.1
AC9M      S4     disabled  pci:0000:00:1f.6

..so it ought to work?

-- 
Mathematics is the supreme nostalgia of our time.
