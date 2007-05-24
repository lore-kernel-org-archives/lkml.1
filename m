Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbXEXW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbXEXW0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXEXW00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:26:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55017 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXEXW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:26:25 -0400
Date: Thu, 24 May 2007 15:25:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.3
Message-ID: <20070524222541.GW3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.3 kernel.
This release has a single security fix in it for the geode-aes driver.
Users with this driver are definitely recommended to upgrade, without
the fix there is risk of leaking confidential data.

798cc279: GEODE-AES: Allow in-place operations [CVE-2007-2451]

I'll also be replying to this message with a copy of the patch between
2.6.21.2 and 2.6.21.3

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

thanks,
-chris

--------

 Makefile                   |    2 +-
 drivers/crypto/geode-aes.c |   12 +++++++++---
 drivers/crypto/geode-aes.h |    3 +--
 3 files changed, 11 insertions(+), 6 deletions(-)

Summary of changes from v2.6.21.2 to v2.6.21.3
============================================

Chris Wright (1):
      Linux 2.6.21.3

Jordan Crouse (1):
      GEODE-AES: Allow in-place operations [CVE-2007-2451]
