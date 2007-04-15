Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXDOKRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXDOKRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXDOKRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:17:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXDOKRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:17:48 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<20070414204924.125386443@goop.org> <46214FD3.3080400@zytor.com>
	<Pine.LNX.4.61.0704151145410.15892@yvahk01.tjqt.qr>
X-Yow: "DARK SHADOWS" is on!!  Hey, I think the VAMPIRE forgot his UMBRELLA!!
Date: Sun, 15 Apr 2007 12:17:24 +0200
In-Reply-To: <Pine.LNX.4.61.0704151145410.15892@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Sun, 15 Apr 2007 11:46:12 +0200 (MEST)")
Message-ID: <jeejmmkkln.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> LOW_PAGES = (0x100000000ULL - __PAGE_OFFSET) >> PAGE_SHIT_asm

The assembler does not now anything about ULL.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
