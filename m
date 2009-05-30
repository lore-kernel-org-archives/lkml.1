Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZE3XPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZE3XPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZE3XPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:15:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56499 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbZE3XPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:15:23 -0400
Date: Sun, 31 May 2009 00:15:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090531001548.571d7b59@lxorguk.ukuu.org.uk>
In-Reply-To: <20090530221024.GA23204@elte.hu>
References: <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com>
	<20090530075033.GL29711@oblivion.subreption.com>
	<4A20E601.9070405@cs.helsinki.fi>
	<20090530082048.GM29711@oblivion.subreption.com>
	<20090530173428.GA20013@elte.hu>
	<20090530180333.GH6535@oblivion.subreption.com>
	<20090530182113.GA25237@elte.hu>
	<20090530184534.GJ6535@oblivion.subreption.com>
	<20090530190828.GA31199@elte.hu>
	<4A21999E.5050606@redhat.com>
	<20090530221024.GA23204@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Obviously the argument is best settled by measurements. Done by 
> whoever wants to push this code.

How do you measure security as a mathematical quantity in a benchtest ?

In terms of performance its pretty easy to stick a counter in kzfree in
2.6.30-rc. The number that comes up is very very low.

Alan
