Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYDYI6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYDYI6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbYDYI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:58:40 -0400
Received: from stardust.frews.de ([80.237.152.89]:38890 "EHLO
	stardust.frews.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbYDYI6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:58:39 -0400
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2008 04:58:39 EDT
Date: Fri, 25 Apr 2008 10:40:07 +0200
From: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-gitX and pmd_bad() on x86_32
Message-ID: <20080425084007.GC14387@stardust.frews.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Yesterday I tried to compile 2.6.25-git5 but I ran into a "Unknown
Symbol" (pmd_bad)  warning from linker while compiling the nvidia-binary module.

I tracked this issue down to this git-commit:
9fc34113f6880b215cbea4e7017fc818700384c2

AFAICS, x86_32 is the only architecture where pmd_bad is neither a
define or a static inline. Including asm/pgtable.h is no longer
sufficient on x868_32. Is this behaviour intended or is there just a
EXPORT_SYMBOL missing?

-- 
Jörg Friedrich

There are only 10 types of people:
Those who understand binary and those who don't.
