Return-Path: <linux-kernel-owner+w=401wt.eu-S934317AbYBAAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbYBAAmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYBAAmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:42:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54723 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752825AbYBAAmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:42:01 -0500
Date: Fri, 1 Feb 2008 01:42:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: how to tell i386 from x86-64 kernel
Message-ID: <20080201004212.GA2818@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Quiz: on a booted system, how do you tell 32bit from 64bit kernel?

A1: zcat /proc/config.gz | grep CONFIG_64

...but config.gz is optional

A2: cat /proc/meminfo  | grep High

...but i386 kernel could have highmem disabled

What is _your_ answer? ;-)>
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
