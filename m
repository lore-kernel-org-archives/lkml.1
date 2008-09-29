Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYI2Xrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYI2Xrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2Xr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:47:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYI2Xr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:47:26 -0400
Date: Tue, 30 Sep 2008 01:52:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: robert.richter@amd.com, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net
Subject: Please pull arch perfmon update
Message-ID: <20080929235253.GA31074@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Robert,

Here are the arch perfmon changes ported to your latest oprofile tree.
I didn't include the forcepmu=... change yet, that will come later.
Right now the force option is just removed. Please pull.

Thanks,
-Andi

The following changes since commit 22d87103484983035cf46891428819573ec7508d:
  Robert Richter (1):
        Merge branch 'oprofile/powerpc-for-paul' into oprofile/master

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git arch-perfmon2

Andi Kleen (4):
      oprofile: drop const in num counters field
      oprofile: Don't report Nehalem as core_2
      oprofile: Implement Intel architectural perfmon support
      oprofile: discover counters for op ppro too

 arch/x86/oprofile/nmi_int.c       |   26 ++++++---
 arch/x86/oprofile/op_model_ppro.c |  108 +++++++++++++++++++++++++++++--------
 arch/x86/oprofile/op_x86_model.h  |    9 ++-
 3 files changed, 108 insertions(+), 35 deletions(-)
-- 
ak@linux.intel.com
