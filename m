Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbYEFU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbYEFU7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764545AbYEFU7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:59:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758222AbYEFU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:59:16 -0400
Date: Tue, 6 May 2008 13:58:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KCONFIG: With a simple menuconfig, kernel debugging is
 prettier.
Message-Id: <20080506135844.b0b12d05.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804241928340.20003@localhost.localdomain>
References: <alpine.LFD.1.10.0804241928340.20003@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 19:31:26 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> Implementing kernel debugging with a menuconfig allows for the removal
> of a pile of unnecessary dependencies.

 Kconfig.debug |  112 +++++++++++++++++++++++++---------------------------------
 1 file changed, 49 insertions(+), 63 deletions(-)

I'm afraid,

akpm:/usr/src/25> grep -l lib/Kconfig.debug pc/*.pc
pc/documentation-build-source-files-in-documentation-sub-dir-disable.pc
pc/documentation-build-source-files-in-documentation-sub-dir.pc
pc/git-sched.pc
pc/git-x86-latest.pc
pc/linux-next.pc
pc/make-frame_pointer-default=y.pc
pc/mm-add-a-basic-debugging-framework-for-memory-initialisation.pc
pc/mutex-subsystem-synchro-test-module.pc
pc/page-owner-tracking-leak-detector.pc
pc/profile-likely-unlikely-macros.pc
pc/slab-leaks3-default-y.pc

that our chances of finding a window in which to merge this patch are
pretty darn small.

