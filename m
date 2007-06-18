Return-Path: <linux-kernel-owner+w=401wt.eu-S1765692AbXFRSxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765692AbXFRSxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbXFRSxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:53:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:38649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbXFRSxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:53:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
Date: Mon, 18 Jun 2007 20:53:03 +0200
User-Agent: KMail/1.9.6
Cc: Mike Frysinger <vapier@gentoo.org>, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200706180209.36762.vapier@gentoo.org> <200706181002.21978.vapier@gentoo.org> <20070618183651.GB17112@infradead.org>
In-Reply-To: <20070618183651.GB17112@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706182053.04116.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> asm-i386/msr.h should not be exported to userspace at all, it contains
> nothing but kernel-internal helpers.

Actually rdtsc and rdtscll and potentially rdpmc which is in there can be very 
useful in user space if you know what you're doing. Unfortunately a lot of its users don't,
but not having the include probably won't stop them either.

-Andi
