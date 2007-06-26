Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbXFZVY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbXFZVY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXFZVYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:24:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbXFZVYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:24:20 -0400
Date: Tue, 26 Jun 2007 14:23:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove nobh_{prepare,commit}_write()
Message-Id: <20070626142320.9336df5b.akpm@linux-foundation.org>
In-Reply-To: <1182890938.11569.27.camel@kleikamp.austin.ibm.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070614221555.GY3588@stusta.de>
	<20070626133203.d1aa5383.akpm@linux-foundation.org>
	<1182890938.11569.27.camel@kleikamp.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 15:48:58 -0500
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Tue, 2007-06-26 at 13:32 -0700, Andrew Morton wrote:
> > On Fri, 15 Jun 2007 00:15:55 +0200
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > nobh_{prepare,commit}_write() are no longer used.
> > 
> > wth?  What happened to ext2 and ext3 nobh mode?  They seem to
> > have magically and unchangeloggedly disappeared?
> 
> They were removed with Nick's new aops patches.
           ^secretly
> 

That much I worked out for myself.  It's kinda staggering that a fairly
major feature in two fairly major filesystems got removed without even a
mention in the changelog.  I don't recall having seen it discussed in email
but I obviously missed that bit.

Look, I'm one micron from just dropping the whole lot.  These changes
simply have not received the amount of energy, effort, care, attention and
testing which a change of this magnitude requires.

