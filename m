Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXH1B6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXH1B6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXH1B6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:58:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbXH1B6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:58:13 -0400
Date: Mon, 27 Aug 2007 18:58:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc4
Message-ID: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I lost it, and let two weeks pass between -rc releases. My bad.

As a result, -rc4 is a bit bigger than it would/should have been, but 
hopefully it's all good, and we've fixed most regressions. There's some 
arch updates (MIPS, power, sparc64, s390) and an ACPI update, but the 
rest of it is mainly lots of small fixes (mostly to various random 
drivers). With some scheduler and networking noise.

I think the shortlog is _just_ too big to be posted on the kernel mailing 
list, but since it can mostly be described with the one word "boring", 
it's not a huge loss. As usual, just do

	git shortlog v2.6.23-rc3..v2.6.23-rc4

if you have the git trees to get the all the details on extraneous 
semicolons, missed or duplicate include files, kzalloc conversions, new 
PCI ID's etc etc.

		Linus
