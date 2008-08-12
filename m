Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYHLUME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYHLUME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYHLULy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:11:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:51715 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYHLULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:11:53 -0400
Date: Tue, 12 Aug 2008 13:09:08 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080812200908.GA444@kroah.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com> <20080811173616.GC6103@redhat.com> <20080811223309.GD9810@kroah.com> <20080812194817.GD6056@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812194817.GD6056@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:48:17PM -0400, Jason Baron wrote:
> On Mon, Aug 11, 2008 at 03:33:09PM -0700, Greg KH wrote:
> > On Mon, Aug 11, 2008 at 01:36:16PM -0400, Jason Baron wrote:
> > > On Fri, Aug 08, 2008 at 07:38:51PM -0700, Randy Dunlap wrote:
> > > > On Fri, 8 Aug 2008 17:51:53 -0400 Jason Baron wrote:
> > > > 
> > > > > Few notes...there is still one control file: <debugfs>/dynamic_printk/modules
> > > > > We can split this up now or later, but I kind of like being able to see all
> > > > > the controls in one file. Also, i've used a djb2 hash function in the code,
> > > > > which i'm not sure is under the correct license/copyright, so i just wanted
> > > > > to point that out as well. see: scripts/basic/hash.c. If its an issue, i can
> > > > > find another hash function. 
> > > > 
> > > > What license does it have?  I don't see one.
> > > > 
> > > 
> > > hmmm...a search for djb2 finds a number of users, for example, i found this one
> > > which is covered by GPL2, http://www.telegraphics.com.au/svn/dpa/trunk/symtab.c
> > > is that sufficient to say its ok?
> > 
> > That's a tough call.  I'd run that through the license board of your
> > employer if you have any questions about this, as it is your name with
> > their domain that is going to have the "signed-off-by:" pointing back
> > to.
> > 
> 
> We're ok with the patch as is...i'm including an updated version below, which
> contains some documentation improvements...as you mentioned before, perhaps
> you can include this patch through the driver tree. It should apply with 
> minimal munging, but please point me at a tree, if there are any issues.
> 
> thanks,
> 
> -Jason
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

So close, can I have a good changelog comment with the patch so people
know what it is when they look in the logs?

Care to resend it with that?

thanks,

greg k-h
