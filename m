Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbYGUDYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbYGUDYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759767AbYGUDYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:24:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:41267 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbYGUDYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:24:45 -0400
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Reiser <jreiser@BitWagon.com>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, Nathan Lynch <ntl@pobox.com>
In-Reply-To: <20080718182850.GO9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	 <1216166331-14810-2-git-send-email-ntl@pobox.com>
	 <1216276539.7740.309.camel@pasglop>
	 <20080717000951.5f8cab37.akpm@linux-foundation.org>
	 <20080717221932.GL9594@localdomain>
	 <20080717154218.8981035c.akpm@linux-foundation.org>
	 <487FD74C.4080603@BitWagon.com>  <20080718182850.GO9594@localdomain>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 13:24:15 +1000
Message-Id: <1216610655.11027.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 13:28 -0500, Nathan Lynch wrote:
> John Reiser wrote:
> > Andrew Morton wrote:
> > > On Thu, 17 Jul 2008 17:19:32 -0500
> > > Nathan Lynch <ntl@pobox.com> wrote:
> > > 
> > > 
> > >> [snip]
> > >> A new aux vector entry, AT_BASE_PLATFORM, will denote the actual hardware.
> > [snip]
> > 
> > > OK.
> > > 
> > > But it conflicts directly with the already-queued
> > > execve-filename-document-and-export-via-auxiliary-vector.patch
> 
> Okay, I can rebase on -mm.

Andrew, we have one other patch (the powerpc bits) on top of that one.
Do you want to carry both in -mm on top of John's patch ? We would like
that in .27 though, I don't know what your merge plans are for John's
patch.

Cheers,
Ben.


