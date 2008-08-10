Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYHJNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYHJNtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYHJNtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:49:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39149 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYHJNtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:49:02 -0400
In-Reply-To: <20080809184759.GB22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain> <20080808190448.GA3356@kroah.com> <20080808191519.GA3704@kroah.com> <20080809184759.GB22905@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <greg@kroah.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] integrity: special fs magic
X-KeepSent: 106327E5:3B04D6A9-852574A1:004B7A96;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OF106327E5.3B04D6A9-ON852574A1.004B7A96-852574A1.004BE526@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Sun, 10 Aug 2008 09:48:58 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/10/2008 09:48:58,
	Serialize complete at 08/10/2008 09:48:58
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 08/09/2008 02:47:59 PM:

 
> On Fri, Aug 08, 2008 at 12:15:19PM -0700, Greg KH wrote:
> > On Fri, Aug 08, 2008 at 12:04:48PM -0700, Greg KH wrote:
> > > On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
> > > >     - Move special fs magic number definitions to magic.h
> > > >     - Add magic.h include
> > > > 
> > > >     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > 
> > > Why?  What is this patch for?  Are you going to do something with 
these
> > > magic values later?
> > 
> > Ok, I now see the follow-up patch that does something with them.
> > 
> > You should say so in this patch.
> > 
> > And is it really ok to be doing things from userspace based on a
> > filesystem "magic" key?  Those are numbers we have never exported to
> > userspace before, what happens if they are changed?
> 
> These constants re exported to userspace in struct statfs .type and
> better don't change.  Providing the symbolic names for them sounds
> like a good idea to me.  What userspace does with that or not is
> their business, and if it's utterly stupid it'll be their fault if
> it doesn't work as expected..

ok.

Mimi
