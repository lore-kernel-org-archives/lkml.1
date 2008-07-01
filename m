Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbYGAOQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbYGAOQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbYGAOQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:16:17 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57125 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbYGAOQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:16:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fat: cleanup fs/fat/dir.c
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
	<20080701122204.GC25580@infradead.org>
Date: Tue, 01 Jul 2008 23:16:11 +0900
In-Reply-To: <20080701122204.GC25580@infradead.org> (Christoph Hellwig's
	message of "Tue, 1 Jul 2008 08:22:04 -0400")
Message-ID: <87bq1hvges.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Jul 01, 2008 at 11:57:03AM +0900, OGAWA Hirofumi wrote:
>> 
>> This is no logic changes, just cleans fs/fat/dir.c up.
>
> I don't think it makes sense to mark the new functions inline, they are
> quite big, and if it really makes sense to inline them the compiler will
> do it for us.

I know people hate inline, me too recently. But, I also know old gcc is
not smart. Actually the optimize by hand was much faster (although it's
not kernel).

I've tested this without inline. gcc-3.4.6 doesn't inlined
fat_name_match(), but gcc-4.3.1 inlined it.

What do you think? If you still think it shouldn't, I'll remove it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
