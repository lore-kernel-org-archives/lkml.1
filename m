Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952Ab0ARSvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0ARSvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931Ab0ARSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:50:12 -0500
Received: from kroah.org ([198.145.64.141]:46230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0ARSuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:50:07 -0500
Date: Mon, 18 Jan 2010 10:44:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.44
Message-ID: <20100118184421.GA25918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.44 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 -
 arch/powerpc/kernel/align.c     |   63 +++++++++++++++++++++++++++++-----------
 arch/powerpc/kernel/fpu.S       |    5 +++
 arch/powerpc/kernel/misc_64.S   |    8 +++++
 kernel/audit_tree.c             |   13 +++++---
 kernel/signal.c                 |    3 +
 net/bridge/netfilter/ebtables.c |    6 +++
 7 files changed, 76 insertions(+), 24 deletions(-)

Al Viro (2):
      fix braindamage in audit_tree.c untag_chunk()
      fix more leaks in audit_tree.c tag_chunk()

Andi Kleen (1):
      kernel/signal.c: fix kernel information leak with print-fatal-signals=1

Florian Westphal (1):
      netfilter: ebtables: enforce CAP_NET_ADMIN

Greg Kroah-Hartman (1):
      Linux 2.6.27.44

Michael Neuling (1):
      powerpc: Disable VSX or current process in giveup_fpu/altivec

Neil Campbell (1):
      powerpc: Handle VSX alignment faults correctly in little-endian mode

