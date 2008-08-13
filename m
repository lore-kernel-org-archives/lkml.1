Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYHMHsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYHMHsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYHMHsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:48:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37102 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYHMHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:48:00 -0400
Date: Wed, 13 Aug 2008 09:34:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] x86: Remove EXPERIMENTAL restriction from
	CONFIG_HOTPLUG_CPU
Message-ID: <20080813073403.GA1830@elf.ucw.cz>
References: <20080811154646.GB8181@sgi.com> <20080811163111.GD4524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811163111.GD4524@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-11 18:31:11, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU on 
> > the x86 architecture.
> >
> > One question, should we default to 'Y'?
> 
> CONFIG_SUSPECT will select it anyway, and when suspend is disabled

Nice typo ;-).

> So i've clarified the text as per the commit below - is this fine with 
> you?
> 
> 	Ingo
> 
> ------------------>
> >From 7c13e6a3d15a4ebcc3f40df5f4d19665479f8ca3 Mon Sep 17 00:00:00 2001
> From: Dimitri Sivanich <sivanich@sgi.com>
> Date: Mon, 11 Aug 2008 10:46:46 -0500
> Subject: [PATCH] x86: remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
> 
> This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
> on the x86 architecture.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
