Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYCNUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYCNUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYCNUBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:01 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48231 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbYCNUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:00 -0400
Message-Id: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:01 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 0/8] NTP updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches clean up the NTP code a little and add the remaining user
space bits from the ntp nanokernel, so that it's e.g. now possible to
enable the nanosecond resolution, which should be useful to keep time in
a local network in sync (but it also needs an updated glibc/ntpd first).

I tried my best to also update the various user space APIs (e.g. compat,
vsyscall), but it would be great if someone could look over it, in case
I forgot something.

bye, Roman

-- 

