Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXDOJ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXDOJ66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXDOJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:58:58 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37296 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbXDOJ65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:58:57 -0400
Date: Sun, 15 Apr 2007 11:46:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
In-Reply-To: <46214FD3.3080400@zytor.com>
Message-ID: <Pine.LNX.4.61.0704151145410.15892@yvahk01.tjqt.qr>
References: <20070414204154.871250608@goop.org> <20070414204924.125386443@goop.org>
 <46214FD3.3080400@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 14 2007 15:04, H. Peter Anvin wrote:
>
> Jeremy Fitzhardinge wrote:
>> -
>> +LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
>> +
>
> Again, for debugging... it would be interesting to replace this with:
>
> LOW_PAGES = (0x100000000-__PAGE_OFFSET) >> PAGE_SHIFT_asm

LOW_PAGES = (0x100000000ULL - __PAGE_OFFSET) >> PAGE_SHIT_asm


Jan
-- 
