Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYBOMA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYBOMA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYBOMAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:00:47 -0500
Received: from mail.suse.de ([195.135.220.2]:58583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYBOMAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:00:46 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Sam Ravnborg <sam@ravnborg.org>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux Tiny)
From: Andi Kleen <andi@firstfloor.org>
References: <20080212110825.35db27cb@crazy>
	<20080212130428.GA32757@uranus.ravnborg.org>
	<20080212150013.57cb954e@crazy>
	<1202832132.12383.93.camel@cinder.waste.org>
Date: Fri, 15 Feb 2008 13:00:42 +0100
In-Reply-To: <1202832132.12383.93.camel@cinder.waste.org> (Matt Mackall's message of "Tue\, 12 Feb 2008 10\:02\:12 -0600")
Message-ID: <p73tzkazaxh.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:
>
> I bet there's some doublefault-handling code hiding somewhere. It's not
> the sort of thing it'd make sense to take out of the architecture.

The big question is if it makes sense taking out of a kernel at all.
I still think the answer is no.

Or have you considered replacing die() and show_trace() etc. with a single
panic("the tiny gods say this won't happen") yet? That would be roughly 
equivalent.

-Andi
