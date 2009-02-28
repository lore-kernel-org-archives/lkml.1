Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZB1NHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZB1NHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZB1NHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:07:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:13787 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZB1NHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k2wgFCExYIQDmb0mDlAkQQrF94ipy5C7uqoqRP2Paq590zWi2VNHpIYQ9R070Gvs1M
         8Xvh2xHZ0m+p0tfGkOXeAgqHqvC2hjoA7Ze1KqZcpSxK10nJRo98MyXFMcTdyXfb4K1f
         bRDCvRuZs77ClSUu9lSbMBRLjMFTllbvKBUNo=
Date: Sat, 28 Feb 2009 14:07:32 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck fix for -tip
Message-ID: <20090228130732.GA19243@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a fix for the "Fatal error". It seems that we missed a few of the
places where page tables are allocated. In any case, this fixes it for me,
please let me know if you see any more fatal errors after this.

The following changes since commit 39bc66625d7a761f6e5c5b3d81d88e7c9359ca84:
  Ingo Molnar (1):
        kmemcheck: fix split_page() of the page allocator, fix

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Vegard Nossum (2):
      x86: don't track page tables with kmemcheck
      Revert "kmemcheck: disable CPA self-test"

 arch/x86/Kconfig.debug |    1 -
 arch/x86/mm/init_64.c  |    4 ++--
 arch/x86/mm/pageattr.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)


Vegard
