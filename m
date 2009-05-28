Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZE1G04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZE1G04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZE1G0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:26:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53020 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751965AbZE1G0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:26:48 -0400
Date: Thu, 28 May 2009 07:27:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090528072702.796622b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090527223421.GA9503@elte.hu>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090523124944.GA23042@elte.hu>
	<4A187BDE.5070601@redhat.com>
	<20090527223421.GA9503@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As for being swapped out - I do not believe that kernel stacks can 
> > ever be swapped out in Linux.
> 
> yes, i referred to that as an undesirable option - because it slows 
> down pthread_create() quite substantially.
> 
> This needs before/after pthread_create() benchmark results.

kernel stacks can end up places you don't expect on hypervisor based
systems.

In most respects the benchmarks are pretty irrelevant - wiping stuff has
a performance cost, but its the sort of thing you only want to do when
you have a security requirement that needs it. At that point the
performance is secondary.

Alan
