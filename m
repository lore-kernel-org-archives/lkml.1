Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZAFUJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZAFUJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZAFUJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:09:06 -0500
Received: from mail.fieldses.org ([141.211.133.115]:56610 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZAFUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:09:03 -0500
Date: Tue, 6 Jan 2009 15:08:54 -0500
To: David Howells <dhowells@redhat.com>
Cc: hch@lst.de, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix NFSD regression
Message-ID: <20090106200854.GD5901@fieldses.org>
References: <20090106194101.GB5901@fieldses.org> <806.1231174132@redhat.com> <20090105171937.4463.98583.stgit@warthog.procyon.org.uk> <28704.1231271771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28704.1231271771@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 07:56:11PM +0000, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > OK, I've tested this and applied it for 2.6.29.
> > 
> > Though it only actually fixes the regression if your other patch ("CRED:
> > Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2")
> > is also applied.  I'd like to send in my pull request today, but I
> > usually try not to send a pull request whose tip doesn't pass at least
> > my basic regression tests....  And that other patch is outside my
> > baliwick.    Can someone else handle it?
> 
> Well, if you're willing to supply an Acked-by or Tested-by for one or both
> patches I can pass them on to James or Linus.

The nfsd-specific one I've already signed off on and queued for Linus.
For the other one, sure, for what it's worth:

	Tested-by: J. Bruce Fields <bfields@citi.umich.edu>

Thanks!--b.
