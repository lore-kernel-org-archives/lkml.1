Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYEILJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYEILJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYEILJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:33 -0400
Received: from gw.goop.org ([64.81.55.164]:47555 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYEILJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86: use PTE_MASK consistently
Message-Id: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:38 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a series to rationalize the use of PTE_MASK and remove some
amount of ad-hocery.

This gist of the series is:
 1. Fix the definition of PTE_MASK so that its equally applicable in
    all pagetable modes
 2. Use it consistently

I haven't tried to address the *_bad() stuff, other than to convert
pmd_bad_* to use PTE_MASK.

I've compile tested it a bit and run it on 32-bit PAE (native and
Xen), but I haven't tested it with >4G memory, non-PAE or 64-bit.  In
other words, it needs some time in Ingo's torture machine.

      J

