Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbZC3SWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbZC3SWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZC3SP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:56614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZC3SPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:20 -0400
Message-Id: <20090330180215.951354436@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 00/35] Jeff's ReiserFS Patch Queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all -

I'd like to submit my reiserfs patch queue for inclusion into 2.6.30. I've
received a bunch of requests from Christoph asking me to do this over the
past two years. They needed some cleaning up (done), and there was one final
crash that prevented me from submitting to 2.6.27 and 2.6.28, which has now
been fixed. These patches have been in several openSUSE releases and, outside
of the now-fixed crash, they've been stable. Once this is applied, I expect
reiserfs to be in deep maintenance-only mode.

There are 35 patches in several groups:

- Quick fixes
  - Implement mount count and expiry in the superblock.
  - Audit commit id's to always be unsigned ints
- Better error handling and reporting
  - Standardizes error output
  - Adds more robust error handling where it will currently panic
- Extended attribute rework
  - Cleans up the code
  - Improves locking
  - Journals extended attributes
  - Adds selinux support
  - Uses generic xattr helpers
- Code cleanups
  - Simplifies the buffer_info struct usage
  - Kills off decrement_bcount and cleans up surrounding code
  - Strips whitespace
  - Kills off the stupid variable name prefixing

Please apply.

-Jeff

--
Jeff Mahoney
SUSE Labs

