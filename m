Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYLBTdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYLBTdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYLBTbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:31:25 -0500
Received: from kroah.org ([198.145.64.141]:43046 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755033AbYLBTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:30:51 -0500
Date: Tue, 2 Dec 2008 11:29:52 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 2 (staging)
Message-ID: <20081202192952.GA2329@kroah.com>
References: <20081202173101.e2b72437.sfr@canb.auug.org.au> <49357AD0.7090005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49357AD0.7090005@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 10:13:36AM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20081201:
> > 
> > Today's tree fails the powerpc allyesconfig build.
> 
> Greg,
> FYI, the staging drivers still have lots of errors (as reported
> over 1 week ago; yes, I know, holiday time), but I've stopped reporting
> on them until I see some reason to think that fixes have been made.

I've fixed the errors that I can in my tree.  The majority of the errors
you are seeing are ones that are caused by api changes in other trees
that I can't fix up now in -staging until those changes go into Linus's
tree.

Which is fine, I'll fix them up when I push them to Linus, so you don't
have to worry about them.

Some of the other warnings are just due to horrible code, like the
drivers/staging/otus/ driver that has some looney macros that cause lots
of build warnings.  Those will take more work and I'm hoping that the
community of developers that have been helping out with the staging tree
will help there.

thanks,

greg k-h
