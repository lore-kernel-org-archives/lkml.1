Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXFWLAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXFWLAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXFWK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:59:27 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:59931 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXFWK70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:59:26 -0400
Date: Sat, 23 Jun 2007 12:49:20 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] fbdev: uvesafb
Message-ID: <20070623104920.GA12623@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

uvesafb is a generic driver for VBE2+ compliant video cards; an enhanced
version of vesafb and a direct successor of vesafb-tng [1].

uvesafb uses a userspace helper application (v86d, [2]) to run the x86
Video BIOS code.  This makes it possible to include in uvesafb all the
standard features (refresh rate control, video mode changes etc) that
are missing from vesafb without resorting to ugly hacks such as the ones
used in [1].  The current implementation of v86d can use either LRMI or
x86emu to run the BIOS code and supports both x86 and x86_64.

[1] http://dev.gentoo.org/~spock/projects/vesafb-tng/
[2] http://dev.gentoo.org/~spock/projects/uvesafb/

Best regards.
-- 
Michal Januszewski                              JID: spock@im.gentoo.org
Gentoo Linux Developer                    http://people.gentoo.org/spock

