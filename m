Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYCORcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYCORcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYCORch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:32:37 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:11414 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYCORcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:32:36 -0400
Date: Sat, 15 Mar 2008 18:29:14 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [0/3] Improve generic fls64 for 64-bit machines
Message-ID: <20080315172913.GA21648@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sat, 15 Mar 2008 18:31:49 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.31; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches:

[1/3] adds __fls.h to asm-generic
[2/3] modifies asm-*/bitops.h for 64-bit archs to implement __fls
[3/3] modifies asm-generic/fls64.h to make use of __fls

I have compiled i386 and x86_64, and they generate the same code as
before the change. The changes to the other archs are a best effort.
Please comment.

If this patch series is accepted, it will make one tiny bit of
the x86-unification a tiny bit cleaner. The patches are against
Linus' current tree.

Andrew, if no concensus can be reached that this is a bad patch
series, would you be willing to add this to your tree?

Greetings,
	Alexander
