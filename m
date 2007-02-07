Return-Path: <linux-kernel-owner+w=401wt.eu-S1161051AbXBGJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051AbXBGJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161047AbXBGJEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:04:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:39425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030597AbXBGJEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:04:30 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Wed, 7 Feb 2007 01:04:24 -0800
User-Agent: KMail/1.9.5
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051813.26958.agruen@suse.de> <20070206095231.GD5328@infradead.org>
In-Reply-To: <20070206095231.GD5328@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702070104.24450.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 01:52, Christoph Hellwig wrote:
> On Mon, Feb 05, 2007 at 06:13:26PM -0800, Andreas Gruenbacher wrote:
> > On Monday 05 February 2007 10:44, Christoph Hellwig wrote:
> > > Looking at the actual patches I see you're lazy in a lot of places.
> > > Please make sure that when you introduce a vfsmount argument somewhere
> > > that it is _always_ passed and not just when it's conveniant.  Yes,
> > > that's more work, but then again if you're not consistant anyone
> > > half-serious will laught at a security model using this infrasturcture.
> >
> > It may appear like laziness, but it's not. Let's look at where we're
> > passing NULL at the moment:
>
> You know, I've tracked a lot of this down previously when I submitted
> patches to add vfsmount arguments to the vfs_ helpers, just to get tought
> by Al that this is a bad idea :)

Hmmm, I really would like to know how else we could get at that information in 
the lsm hooks then.

Andreas
