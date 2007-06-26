Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbXFZVfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbXFZVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFZVe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:34:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11591 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:34:56 -0400
Date: Tue, 26 Jun 2007 14:33:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove nobh_{prepare,commit}_write()
Message-Id: <20070626143335.684887f9.randy.dunlap@oracle.com>
In-Reply-To: <20070626142320.9336df5b.akpm@linux-foundation.org>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070614221555.GY3588@stusta.de>
	<20070626133203.d1aa5383.akpm@linux-foundation.org>
	<1182890938.11569.27.camel@kleikamp.austin.ibm.com>
	<20070626142320.9336df5b.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:23:20 -0700 Andrew Morton wrote:

> On Tue, 26 Jun 2007 15:48:58 -0500
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2007-06-26 at 13:32 -0700, Andrew Morton wrote:
> > > On Fri, 15 Jun 2007 00:15:55 +0200
> > > Adrian Bunk <bunk@stusta.de> wrote:
> > > 
> > > > nobh_{prepare,commit}_write() are no longer used.
> > > 
> > > wth?  What happened to ext2 and ext3 nobh mode?  They seem to
> > > have magically and unchangeloggedly disappeared?
> > 
> > They were removed with Nick's new aops patches.
>            ^secretly
> > 
> 
> That much I worked out for myself.  It's kinda staggering that a fairly
> major feature in two fairly major filesystems got removed without even a
> mention in the changelog.  I don't recall having seen it discussed in email
> but I obviously missed that bit.
> 
> Look, I'm one micron from just dropping the whole lot.  These changes
> simply have not received the amount of energy, effort, care, attention and
> testing which a change of this magnitude requires.

so be sure to discuss that (not the patches themselves so much,
but the process(es)) at the kernel summit etc....


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
