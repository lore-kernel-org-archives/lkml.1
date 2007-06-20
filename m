Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbXFTAOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbXFTAOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXFTAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:14:10 -0400
Received: from kumera.dghda.com ([80.68.90.171]:4262 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbXFTAOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:14:09 -0400
From: "Duane Griffin" <duaneg@dghda.com>
Message-Id: <20070620000644.891099313@dastardly.home.dghda.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 01:06:44 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, didier <did447@gmail.com>,
       Solra Bizna <sbizna@tejat.net>, Daniel Drake <dsd@gentoo.org>
Subject: [patch 0/2] HFS+: custom dentry hash and comparison operations
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The HFS+ filesystem is case-insensitive and does automatic unicode
decomposition by default, but does not provide custom dentry
operations. This can lead to multiple dentries being cached for lookups
on a filename with varying case and/or character (de)composition.

These patches add custom dentry hash and comparison operations for
case-sensitive and/or automatically decomposing HFS+ filesystems.
Unicode decomposition and case-folding are performed as required to
ensure equivalent filenames are hashed to the same values and compare
as equal.

Tested on i386, x86_64 and PPC.

See bug reports here for more information:
http://bugzilla.kernel.org/show_bug.cgi?id=7240
http://bugs.gentoo.org/show_bug.cgi?id=178298

Cheers,
Duane Griffin.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
