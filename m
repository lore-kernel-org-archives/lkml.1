Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758953AbYLPX1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYLPX1o (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbYLPX1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:27:06 -0500
Received: from kroah.org ([198.145.64.141]:51554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759085AbYLPX1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:27:02 -0500
Date: Tue, 16 Dec 2008 15:21:16 -0800
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Harry Edmon <harry@atmos.washington.edu>, linux-nfs@vger.kernel.org,
        Max Kellermann <max@duempel.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
Message-ID: <20081216232116.GD6983@kroah.com>
References: <20081022091207.GA12996@squirrel.roonstrasse.net> <20081023123628.GA18549@squirrel.roonstrasse.net> <1224773745.7625.4.camel@localhost> <4946EBFA.60700@atmos.washington.edu> <1229432553.7257.4.camel@heimdal.trondhjem.org> <20081216212155.GA581@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216212155.GA581@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:21:55PM +0100, Willy Tarreau wrote:
> On Tue, Dec 16, 2008 at 08:02:33AM -0500, Trond Myklebust wrote:
> > > and I am not using Kerberos with NFSv4 (i.e. no rpc.gssd).  Did you ever 
> > > find a solution for this problem with rpcauth_lookup_credcache?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=23918b03060f6e572168fdde1798a905679d2e06
> 
> Trond, this should be included into next stable, right ?
> 
> It's fortunate because I know someone else who recently described me the
> same problem under the same circumstances when migrating from 2.6.22 to
> 2.6.27.

Now queued up in the 2.6.27-stable queue.

thanks,

greg k-h
