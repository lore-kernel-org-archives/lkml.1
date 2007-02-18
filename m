Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbXBRFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbXBRFWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXBRFWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:22:14 -0500
Received: from artemis.sr.unh.edu ([132.177.249.69]:19554 "EHLO
	artemis.sr.unh.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbXBRFWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:22:14 -0500
Date: Sun, 18 Feb 2007 00:22:10 -0500 (EST)
From: Kai Germaschewski <kai.germaschewski@unh.edu>
X-X-Sender: kai@artemis.sr.unh.edu
To: Tilman Schmidt <tilman@imap.cc>
cc: Adrian Bunk <bunk@stusta.de>, Hansjoerg Lipp <hjlipp@web.de>,
       gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
In-Reply-To: <45D74B46.3090602@imap.cc>
Message-ID: <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007, Tilman Schmidt wrote:

> Alright, then so be it. But that raises another question:
> asyncdata.o is only needed for M105 and M101, not for the base
> driver. How do I express in Kbuild that asyncdata.o is to be added
> to gigaset-y only if CONFIG_GIGASET_M105 and CONFIG_GIGASET_M101
> are not both 'n'?

The way this is typically done is via Kconfig. Add a config option 
ASYNCDATA (actually something more descriptive/specific would be better), 
add a "select ASYNCDATA" to the config options for m101 and m105, and then 
you can use CONFIG_ASYNCDATA to decide whether to add asyncdata.o in the 
Makefile.

--Kai


