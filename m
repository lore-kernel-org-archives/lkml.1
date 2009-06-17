Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbZFQXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbZFQXQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZFQXQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:16:00 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:65005 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbZFQXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:15:59 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/2] Revert and reimplement Add SGMII support to UCC GETH
To: Stephen Rothwell <sfr@canb.auug.org.au>, subrata@linux.vnet.ibm.com,
       netdev@vger.kernel.org
Cc: Kumar Gala <galak@kernel.crashing.org>, Li Yang <leoli@freescale.com>,
       Nathan Lynch <ntl@pobox.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Tony Breeds <tony@bakeyournoodle.com>, michael@ellerman.id.au,
       Haiying Wang <Haiying.Wang@freescale.com>, davem@davemloft.net
Date: Wed, 17 Jun 2009 17:15:58 -0600
Message-ID: <20090617231306.7051.56146.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(REPOST; I messed up an email address first time around and apparently my
posting got rejected.  If you've already received this message, then
I apologize for the noise)

Here is a fix for the build failure discovered during the 2.6.31 merge
window on ucc_geth.c.  I decided to revert and reapply a fixed version
of the patch to make the new version easier to review and bisect if I
got the fixup wrong.  I've compile tested both patches, but I do not have
hardware to run test.

Haiying, please confirm that I haven't horribly trashed your hard work
with my changes.

For anyone interested, I've also pushed these patches out to the -next-net
branch of my git tree:

The following changes since commit 65795efbd380a832ae508b04dba8f8e53f0b84d9:
 Linus Torvalds (1):
       Merge branch 'next-i2c' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

 git://git.secretlab.ca/git/linux-2.6 next-net

Grant Likely (1):
     Revert "net/ucc_geth: Add SGMII support for UEC GETH driver"

Haiying Wang (1):
     net/ucc_geth: Add SGMII support for UCC GETH driver

 drivers/net/ucc_geth.c |  113 +++++++++++++++++++----------------------------
 drivers/net/ucc_geth.h |    2 +-
 2 files changed, 47 insertions(+), 68 deletions(-)


--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
