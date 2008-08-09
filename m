Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYHISsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYHISsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYHISsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:48:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHISsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:48:02 -0400
Date: Sat, 9 Aug 2008 14:47:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20080809184759.GB22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain> <20080808190448.GA3356@kroah.com> <20080808191519.GA3704@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808191519.GA3704@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:15:19PM -0700, Greg KH wrote:
> On Fri, Aug 08, 2008 at 12:04:48PM -0700, Greg KH wrote:
> > On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
> > >     - Move special fs magic number definitions to magic.h
> > >     - Add magic.h include
> > >     
> > >     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > 
> > Why?  What is this patch for?  Are you going to do something with these
> > magic values later?
> 
> Ok, I now see the follow-up patch that does something with them.
> 
> You should say so in this patch.
> 
> And is it really ok to be doing things from userspace based on a
> filesystem "magic" key?  Those are numbers we have never exported to
> userspace before, what happens if they are changed?

These constants re exported to userspace in struct statfs .type and
better don't change.  Providing the symbolic names for them sounds
like a good idea to me.  What userspace does with that or not is
their business, and if it's utterly stupid it'll be their fault if
it doesn't work as expected..
