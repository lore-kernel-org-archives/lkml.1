Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXCRU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXCRU5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXCRU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:57:50 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48220 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXCRU5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:57:49 -0400
Date: Sun, 18 Mar 2007 21:57:18 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: whence CONFIG_PROVE_SPIN_LOCKING?
In-Reply-To: <Pine.LNX.4.64.0703181619540.19832@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.64.0703182156550.12394@twin.jikos.cz>
References: <Pine.LNX.4.64.0703181619540.19832@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Robert P. J. Day wrote:

> $ grep -r PROVE_SPIN_LOCKING *
> Documentation/irqflags-tracing.txt:CONFIG_TRACE_IRQFLAGS_SUPPORT is needed for CONFIG_PROVE_SPIN_LOCKING
> kernel/spinlock.c:#ifdef CONFIG_PROVE_SPIN_LOCKING

This should almost certainly be CONFIG_PROVE_LOCKING ... ?

-- 
Jiri Kosina
