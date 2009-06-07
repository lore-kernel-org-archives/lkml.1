Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZFGUBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZFGUBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZFGUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:35280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZFGUBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:01:46 -0400
Date: Sun, 7 Jun 2009 20:01:47 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.2
Message-ID: <20090607200147.GA29197@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 20:01:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.37.2.

The main goal was to address a regression brought by 2.4.37.1. The
CAP_KILL fix caused modprobe to leave zombies on auto-loading (easily
seen with CONFIG_IPV6=m).

While working on this, I also merged some fixes which did not get into
2.4.37.1 either because it was too late or because I missed them. The
only really relevant one is the fix for the SCTP overflow (CVE-2009-0065)
which has been demonstrated to be remotely exploitable when an SCTP
application was running.

Users of 2.4.37.1 with modules autoloading enabled are really encouraged
to upgrade.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.2.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.2

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git

Regards,
Willy


Summary of changes from v2.4.37.1 to v2.4.37.2
============================================

David S. Miller (1):
      ipv6: Disallow rediculious flowlabel option sizes.

Eugene Teo (1):
      net: amend the fix for SO_BSDCOMPAT gsopt infoleak

Jesse Brandeburg (1):
      e1000: fix bug with shared interrupt during reset

Neil Horman (1):
      e1000: add missing length check to e1000 receive routine

Wei Yongjun (1):
      sctp: Avoid memory overflow while FWD-TSN chunk is received with bad stream ID

Willy Tarreau (2):
      exit_notify: fix regression uncovered by the CAP_KILL fix
      Change VERSION to 2.4.37.2

