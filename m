Return-Path: <linux-kernel-owner+w=401wt.eu-S965493AbXBRAsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965493AbXBRAsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXBRAs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:48:27 -0500
Received: from thunk.org ([69.25.196.29]:46293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965489AbXBRAsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:48:17 -0500
Date: Sat, 17 Feb 2007 17:49:52 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070217224952.GB16522@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:24PM +0200, Artem Bityutskiy wrote:
> The structure of the UBI code is very simple. Whole UBI consists of units.
> Each unit has one .c file which implements it and one .h file which defines
> the interface of this unit. So I've split the UBI code so that there is
> a distinct patch for each unit header and implementations. Plus there are
> several patches like JFFS2 support, user-space-visible headers, etc.
> To realize what is the unit responsible for, glance at its header - there
> is a short description.

Artem,

        This patch introduces the Makefile before any of the source
files, which means it will break "git bisect" operations.  Could you
please refactor your patches so that the tree will build after any
point in your patch series?  

	BTW, I'm not personally found of having a separate .h file for
every .c file; in my mind a much better division is a public and
private header file.

						- Ted
