Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbXDMCdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbXDMCdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXDMCdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:33:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbXDMCdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:33:04 -0400
Date: Thu, 12 Apr 2007 19:32:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070412193255.62a0b8ed.akpm@linux-foundation.org>
In-Reply-To: <461EE890.2040601@yahoo.com.au>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
	<20070412174201.065068b2.akpm@linux-foundation.org>
	<461ED96C.5030606@yahoo.com.au>
	<20070412182213.a18cc4a7.akpm@linux-foundation.org>
	<461EE005.6070605@yahoo.com.au>
	<20070412185723.5a5f0443.akpm@linux-foundation.org>
	<461EE890.2040601@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 12:18:56 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > I guess one could generate an answer to the static question with systemtap,
> > by accumulating running counts across the application lifetime and then
> > snapshotting them.  Sounds hard though.
> 
> Can't you just traverse arbitrary kernel data structures at a given point
> in time, exactly like the /proc/ call is doing?

Do a full pagetable walk, with all the associated locking from within
a systemtap script?  I'd be surprised.  Maybe if it's mostly hand-coded
in C, perhaps.  Then you just end up with the same thing, don't you?
