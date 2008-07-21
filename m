Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbYGUDlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbYGUDlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYGUDlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:41:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759074AbYGUDlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:41:09 -0400
Date: Sun, 20 Jul 2008 20:40:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: John Reiser <jreiser@BitWagon.com>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
Message-Id: <20080720204008.8927460c.akpm@linux-foundation.org>
In-Reply-To: <1216610655.11027.80.camel@pasglop>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	<1216166331-14810-2-git-send-email-ntl@pobox.com>
	<1216276539.7740.309.camel@pasglop>
	<20080717000951.5f8cab37.akpm@linux-foundation.org>
	<20080717221932.GL9594@localdomain>
	<20080717154218.8981035c.akpm@linux-foundation.org>
	<487FD74C.4080603@BitWagon.com>
	<20080718182850.GO9594@localdomain>
	<1216610655.11027.80.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 13:24:15 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2008-07-18 at 13:28 -0500, Nathan Lynch wrote:
> > John Reiser wrote:
> > > Andrew Morton wrote:
> > > > On Thu, 17 Jul 2008 17:19:32 -0500
> > > > Nathan Lynch <ntl@pobox.com> wrote:
> > > > 
> > > > 
> > > >> [snip]
> > > >> A new aux vector entry, AT_BASE_PLATFORM, will denote the actual hardware.
> > > [snip]
> > > 
> > > > OK.
> > > > 
> > > > But it conflicts directly with the already-queued
> > > > execve-filename-document-and-export-via-auxiliary-vector.patch
> > 
> > Okay, I can rebase on -mm.
> 
> Andrew, we have one other patch (the powerpc bits) on top of that one.
> Do you want to carry both in -mm on top of John's patch ? We would like
> that in .27 though, I don't know what your merge plans are for John's
> patch.
> 

How about I send John's patch Linuswards right now?
