Return-Path: <linux-kernel-owner+w=401wt.eu-S1766915AbXEBRm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766915AbXEBRm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766904AbXEBRm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:42:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:49700 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766915AbXEBRm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:42:58 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
	<20070501142325.09c294bd.akpm@linux-foundation.org>
	<p73slafxvor.fsf@bingen.suse.de> <20070502160436.GA19442@thunk.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 20:40:35 +0200
In-Reply-To: <20070502160436.GA19442@thunk.org>
Message-ID: <p73y7k7vzks.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Wed, May 02, 2007 at 02:21:40PM +0200, Andi Kleen wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > > 
> > > Conceivably we could address this in the filesystem without mucking other
> > > things up.  But I'd have thought the simplest damage-control would be to
> > > detect this pattern in samba and to then use glibc's fallocate().
> > 
> > The advantage of detecting it in kernel would be that it would handle
> > Linux applications that do this (I suspect there are some) too.
> 
> Um, which applications do you suspect?  So we can hunt down those user
> space applications programmers and slap them silly?  Or rather,
> unsilly, since that there's no good reason to ever suspect that
> writing a byte every 128k would result in a good allocation layout on disk?

Anything that uses glibc fallocate() ?

-Andi
