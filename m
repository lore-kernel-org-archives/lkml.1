Return-Path: <linux-kernel-owner+w=401wt.eu-S1751191AbZIHQDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbZIHQDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZIHQDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:03:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750870AbZIHQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:03:46 -0400
Date: Tue, 8 Sep 2009 12:03:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: linux-ide@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Limiting DMA speeds for individual IDE drives
Message-ID: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any simple way to force the old IDE driver to limit the DMA
speed for a particular device?

I've got a situation where a drive claims to be capable of supporting
UDMA/100, but it's in a noisy environment and gets lots of errors at
that speed.  I'd like to limit it to UDMA/66 or even UDMA/33.

The hdparm command should be able to do this but I can't run it until 
the system has booted, by which time a bunch of CRC and possibly other 
errors have already occurred.  Ideally it should be possible to limit 
the speed starting as early as device detection, but I can't find any 
way to do it.  Is there support for such a thing or will I have to hack 
it in?

Thanks,

Alan Stern

