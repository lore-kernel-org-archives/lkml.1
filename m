Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYAaBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYAaBC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYAaBCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:02:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60585
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756829AbYAaBCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:02:47 -0500
Date: Wed, 30 Jan 2008 17:03:06 -0800 (PST)
Message-Id: <20080130.170306.174974383.davem@davemloft.net>
To: mingo@elte.hu
Cc: travis@sgi.com, Geert.Uytterhoeven@sonycom.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] sparc64: Use generic percpu linux-2.6.git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080130215223.GB28242@elte.hu>
References: <20080130180940.022172000@sgi.com>
	<20080130180940.506256000@sgi.com>
	<20080130215223.GB28242@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 30 Jan 2008 22:52:23 +0100

> 
> * travis@sgi.com <travis@sgi.com> wrote:
> 
> > Sparc64 has a way of providing the base address for the per cpu area 
> > of the currently executing processor in a global register.
> > 
> > Sparc64 also provides a way to calculate the address of a per cpu area 
> > from a base address instead of performing an array lookup.
> 
> has this been booted on SPARC64 and does David ACK this conversion?

Conceptually I'm fine with the changes.

I had these for testing in my backlog right before I came to
LCA08 and I won't be able to do any real testing until I get back
home on Feb 4th.
