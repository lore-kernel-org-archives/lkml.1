Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbYKTUga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbYKTUga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYKTUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:35:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62871 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYKTUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:35:53 -0500
Message-Id: <20081120203415.251344054@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 15:34:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>
Subject: [PATCH 0/3] ftrace: updates to recordmcount.pl script
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I took Matt's patch and stripped out all the sh changes, leaving
only the update to recordmcount.pl. Hopefully, this will disappear
when it is pulled into linux-next.

The second patch is the changes needed for PowerPC in the recordmcount.pl
script.

The thrird patch is the cleanup.

All of this is based off of tip/master.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Matt Fleming (1):
      sh: dynamic ftrace support.

Steven Rostedt (2):
      ftrace: add support for powerpc to recordmcount.pl script
      ftrace: create default variables for archs in recordmcount.pl

----
 scripts/recordmcount.pl |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)
