Return-Path: <linux-kernel-owner+w=401wt.eu-S935727AbZLGXHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935727AbZLGXHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965065AbZLGXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:07:20 -0500
Received: from fieldses.org ([174.143.236.118]:49625 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935688AbZLGXHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:07:19 -0500
Date: Mon, 7 Dec 2009 18:07:26 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] SUNRPC: IS_ERR/PTR_ERR confusion
Message-ID: <20091207230726.GA4685@fieldses.org>
References: <4B1CE844.1040108@gmail.com> <20091207152654.GA29416@fieldses.org> <1260227059.2951.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260227059.2951.13.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:04:19PM -0500, Trond Myklebust wrote:
> On Mon, 2009-12-07 at 10:26 -0500, J. Bruce Fields wrote: 
> > On Mon, Dec 07, 2009 at 12:34:28PM +0100, Roel Kluin wrote:
> > > IS_ERR returns 1 or 0, PTR_ERR returns the error value.
> > 
> > Whoops, thanks, looks like that was my mistake, from
> > 79a3f20b641f9f93787ada49d1d7cfa98ee5a11e "rpc: use count of pipe openers
> > to wait for first open".
> 
> Are you planning on shepherding this fix into mainline, or should I?

I don't care, but I think of that as client-side code, so I'm assuming
you're taking it.

--b.
