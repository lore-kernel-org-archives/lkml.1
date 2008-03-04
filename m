Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYCDIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYCDIk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbYCDIkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:40:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbYCDIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:40:15 -0500
Date: Tue, 4 Mar 2008 00:38:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-Id: <20080304003853.290f4dd0.akpm@linux-foundation.org>
In-Reply-To: <20080304080335.GA5776@uranus.ravnborg.org>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>
	<20080303085720.GD15943@elte.hu>
	<20080303091314.GC4457@cs181133002.pp.htv.fi>
	<20080303091714.GA18250@elte.hu>
	<20080303093103.GA23651@uranus.ravnborg.org>
	<20080303103933.GC21190@elte.hu>
	<20080303113451.GF4457@cs181133002.pp.htv.fi>
	<20080303114533.GA4183@elte.hu>
	<20080303121335.GA15381@elte.hu>
	<20080303224231.86c22ed0.akpm@linux-foundation.org>
	<20080304080335.GA5776@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 09:03:59 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:

> > It would be nice to be able to feed the gcc version into the Kconfig logic,
> > really..
> We can do this using a few environment options.
> 
> Somewhere in a Makefile:
> export CC_MAJOR=`magic`
> export CC_MINOR=`more magic`
> 
> And in a Kconfig file:
> 
> config CC_MAJOR
> 	string
> 	option env=CC_MAJOR
> 
> 
> And then we can do:
> config CC_DEFAULT_INLINE
> 	bool "Force inline of functions annotated inline"
> 	default y if CC_MAJOR = 04

Sounds neat.  I guess we should do HOST_CC too.

> Shall I try to cook up a patch for this?
> [I may get access to my dev box tonight - cannot promise..]

accuracy=1/speed.  There's no rush on this ;)
