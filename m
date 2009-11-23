Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZKWXnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZKWXnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZKWXnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:43:05 -0500
Received: from kroah.org ([198.145.64.141]:49602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbZKWXnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:43:04 -0500
Date: Mon, 23 Nov 2009 15:43:00 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
Message-ID: <20091123234300.GA13647@kroah.com>
References: <20091123185232.1423c56b.sfr@canb.auug.org.au>
 <20091123111510.9b0c0714.randy.dunlap@oracle.com>
 <200911240924.54675.rusty@rustcorp.com.au>
 <4B0B1507.4060202@oracle.com>
 <20091124103641.abd7bd6b.sfr@canb.auug.org.au>
 <4B0B1CCA.7070500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B1CCA.7070500@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:37:46PM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi Randy,
> > 
> > On Mon, 23 Nov 2009 15:04:39 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> I decided to check on linux-next (only checked x86_64 allmodconfig),
> >> and viola:
> >>
> >> CONFIG_STAGING=y
> >> CONFIG_STAGING_EXCLUDE_BUILD=y
> >>
> >> That is just too helpful.  :(
> > 
> > The Kconfig was deliberately done so that the all{no,yes,mod}config
> > builds don't build the staging stuff.  You need to explictly ask for it.
> > Otherwise I would spend all my time reporting/fixing errors and warnings
> > in linux-next.
> > 
> 
> no, you should just drop it after one build error.

No.  We've been through this before a while ago.  We want the staging
tree in linux-next to deal with merge issues and to help the developers
who are contributing to it.

If you want to take it out of your automated randconfig builds because
it causes you lots of problems, that's fine with me.

thanks,

greg k-h
