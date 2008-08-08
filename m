Return-Path: <linux-kernel-owner+w=401wt.eu-S1765305AbYHHXQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765305AbYHHXQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764591AbYHHXPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:15:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbYHHXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:15:35 -0400
Date: Fri, 8 Aug 2008 16:07:43 -0700
From: Greg KH <greg@kroah.com>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20080808230743.GB5222@kroah.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain> <20080808190448.GA3356@kroah.com> <20080808191519.GA3704@kroah.com> <OFC0E5DFDC.21CEA1BD-ON8525749F.006C2CBE-8525749F.006CEE93@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFC0E5DFDC.21CEA1BD-ON8525749F.006C2CBE-8525749F.006CEE93@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 03:50:02PM -0400, Mimi Zohar wrote:
> Greg KH <greg@kroah.com> wrote on 08/08/2008 03:15:19 PM:
> 
> > On Fri, Aug 08, 2008 at 12:04:48PM -0700, Greg KH wrote:
> > > On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
> > > >     - Move special fs magic number definitions to magic.h
> > > >     - Add magic.h include
> > > > 
> > > >     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > 
> > > Why?  What is this patch for?  Are you going to do something with 
> these
> > > magic values later?
> > 
> > Ok, I now see the follow-up patch that does something with them.
> > 
> > You should say so in this patch.
> > 
> > And is it really ok to be doing things from userspace based on a
> > filesystem "magic" key?  Those are numbers we have never exported to
> > userspace before, what happens if they are changed?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Userspace only loads the measurement policy (via securityfs), and if
> a magic number changes, and the policy is not updated to match, then
> we would end up measuring some filesystems we didn't need to.  Before 
> the magic numbers were hard coded in IMA, now at least, it's extensible. 

Why not just use a name then instead?  That way if the number changes
within the kernel, then it will always be right.

thanks,

greg k-h
