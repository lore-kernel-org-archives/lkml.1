Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZBIWsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZBIWsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZBIWsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:48:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbZBIWsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:48:15 -0500
Date: Mon, 9 Feb 2009 14:48:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, ian@beware.dropbear.id.au
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-Id: <20090209144803.821aa33e.akpm@linux-foundation.org>
In-Reply-To: <20090209220830.GA15633@ioremap.net>
References: <20090209214217.GA14958@ioremap.net>
	<20090209135641.0367a71f.akpm@linux-foundation.org>
	<20090209220830.GA15633@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 01:08:30 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> > Please provide changelogs.  This bugfix is applicable to 2.6.28.x and
> > probably earlier.  But due to the lack of any supporting information I
> > am not in a position to determine whether it should be backported.
>  
> That's what was placed into the documentation iirc, code for the more
> advanced chip works ok. This code exists for way too long, but
> apparently did not grow higher than 32 degrees, so it is applicable for
> the earlier trees either.

I think the above means that the patch is appropriate for earlier trees.

But we still don't have a _reason_.  Presumably the bug causes the
driver to malfunction in some manner.

There are two reasons for properly describing the patch:

a) the stable maintainers will want to understand why they should
   backport the patch - does the bug affect anyone and if so, how?

b) people who are using earlier kernel versions and who experience a
   bug will want to know whether this patch will fix their bug.  To do
   that, they will need a description of what the patch fixes!

So please, do describe the user-visible impact of the bug if that is at
all relevant or possible.
