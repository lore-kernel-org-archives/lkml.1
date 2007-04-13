Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXDMBvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXDMBvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXDMBvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:51:14 -0400
Received: from waste.org ([66.93.16.53]:59700 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXDMBvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:51:13 -0400
Date: Thu, 12 Apr 2007 20:38:40 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413013840.GK11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070413002538.GJ11115@waste.org> <461ED675.3060909@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461ED675.3060909@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 11:01:41AM +1000, Nick Piggin wrote:
> >Basically: to show what the hell's going on in the VM.
> 
> kprobes / systemtap isn't good enough?

It's not really a good match to the kprobes model. I'm not interested
in events, per se. I don't want to need to know about every single
alloc/free of N different varieties integrated from boot onward to
build up an image of the state of the system. Instead, I want to take
snapshots of the state of the VM.

The main goal here is to be able to answer the question "where's my
memory going?". Currently you can't really give a good answer to that
question from userspace because of shared mappings, etc.

There are lots of secondary questions that follow on very quickly from
that, like "what parts of my shared mappings are or aren't shared, and
why?", "what's actually in my application's working set?" and "how much
of this crap can I ditch?".

-- 
Mathematics is the supreme nostalgia of our time.
