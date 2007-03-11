Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXCKVYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXCKVYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXCKVYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:24:09 -0400
Received: from smtp-out109.alice.it ([85.37.17.109]:1309 "EHLO
	smtp-out109.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbXCKVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:24:08 -0400
Date: Sun, 11 Mar 2007 22:26:52 +0100
From: Giuliano Pochini <pochini@shiny.it>
To: linux-kernel@vger.kernel.org
Subject: /sys/devices/system/cpu/cpuX/online are missing
Message-Id: <20070311222652.5ea40da1.pochini@shiny.it>
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2007 21:23:38.0225 (UTC) FILETIME=[88A13E10:01C76423]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Since 2.6.20 /sys/devices/system/cpu/cpuX/online isn't there anymore. The
directories exist, though. I also tested linux-2.6.21rc3. I had a look at the
archives and I found nothing about the removal of that file, which is still
documented in Documentation/cpu-hotplug.txt. I don't know if other
architectures are affected.

$ uname -a
Linux Jay 2.6.20 #1 SMP Mon Feb 5 22:42:18 CET 2007 ppc 7455, altivec supported PowerMac3,6 GNU/Linux

No cpusets. CONFIG_HOTPLUG_CPU=y


--
Giuliano.
