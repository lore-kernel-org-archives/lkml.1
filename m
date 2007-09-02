Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXIBTtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXIBTtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXIBTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:49:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37456 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXIBTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:49:04 -0400
Date: Mon, 3 Sep 2007 01:32:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [-mm patchset] War on warnings
Message-ID: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I decided to ruin my Sunday with an utterly pointless activity --
waging war on -mm build warnings. Some of the code I touched belonged
to grotty, unused, dying drivers, but still, the end result was that
I can now only see 5 warnings remaining on my typical .config (those
have to do with pci_{find,enable}_device deprecation and __must_check
on sysfs_create_{file,link} so I'll just leave 'em for now).

Some were unused variable warnings, some uninitialized (few of those
real bugs, but most not), some were "function defined but not used",
some function argument signedness mismatches, some __must_check fixes,
some tricky, but most just trivial.

So till the next kernel release adds back shiny new build warnings,
here's to some temporary peace ...
