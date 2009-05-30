Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbZE3XM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbZE3XM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZE3XMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:12:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56490 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251AbZE3XMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:12:51 -0400
Date: Sun, 31 May 2009 00:13:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Larry H." <research@subreption.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090531001318.093e3665@lxorguk.ukuu.org.uk>
In-Reply-To: <20090530213311.GM6535@oblivion.subreption.com>
References: <20090530075033.GL29711@oblivion.subreption.com>
	<4A20E601.9070405@cs.helsinki.fi>
	<20090530082048.GM29711@oblivion.subreption.com>
	<20090530173428.GA20013@elte.hu>
	<20090530180333.GH6535@oblivion.subreption.com>
	<20090530182113.GA25237@elte.hu>
	<20090530184534.GJ6535@oblivion.subreption.com>
	<20090530190828.GA31199@elte.hu>
	<4A21999E.5050606@redhat.com>
	<84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
	<20090530213311.GM6535@oblivion.subreption.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was pointing out that the 'those test and jump/call branches have
> performance hits' argument, while nonsensical, applies to kzfree and
> with even more negative connotations (deeper call depth, more test
> branches used in ksize and kfree, lack of pointer validation).

But they only apply to kzfree - there isn't a cost to anyone else. You've
move the decision to compile time which for the fast path stuff when you
just want to clear keys and other oddments is a big win.
