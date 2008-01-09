Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYAINVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYAINVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYAINUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:20:54 -0500
Received: from twin.jikos.cz ([213.151.79.26]:50525 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYAINUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:20:53 -0500
Date: Wed, 9 Jan 2008 14:19:58 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: David Miller <davem@davemloft.net>
cc: hch@lst.de, airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       pq@iki.fi, jbeulich@novell.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
In-Reply-To: <20080108.232223.211829980.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0801091418510.25041@twin.jikos.cz>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
 <20080109071727.GA10695@lst.de> <20080108.232223.211829980.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, David Miller wrote:

> You can set a kprobe on the x86 fault handler to do things like
> mmiotrace.

Currently, on x86, you can not, because:

	fastcall void __kprobes do_page_fault( ... );

-- 
Jiri Kosina
