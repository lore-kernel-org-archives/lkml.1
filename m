Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYB2B00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYB2B00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYB2B0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:26:15 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:32450 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751254AbYB2B0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:26:14 -0500
X-YMail-OSG: sWnab6YVM1l72dXcnsvFylqPjZBGYaTMASMgvR1fiiqIoDJXWhn4q4Cd..D5PKJcoT86Vao2aQ--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 17:26:13 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Hellwig <hch@infradead.org>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204246206.7363.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <227831.22689.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Thu, 2008-02-28 at 19:39 -0500, Christoph Hellwig wrote:
> > On Thu, Feb 28, 2008 at 07:04:57PM -0500, Dave Quigley wrote:
> > > There are several things here. I've spoken to several people about this
> > > and the belief I've gotten from most of them is that a recommended
> > > attribute is how this is to be transported. The NFSv4 spec people will
> > > probably say that if you want xattr like functionality for NFSv4 use
> > > named attributes. For us this is not an option since we require
> > > semantics to label on create/open and the only way we can do this is by
> > > adding a recommended attribute. The create/open calls in NFSv4 takes a
> > > list of attributes to use on create as part of the request. I really
> > > don't see a difference between the security blob and the
> > > username/groupname that NFSv4 currently uses. Also there is a good
> > > chance that we will need to translate labels at some point (read future
> > > work).
> > 
> > Then use the existing side-band protocol and ignore the NFSv4 spec
> > group.  They're <skip colourful language here> anyway.
> 
> As I've told you several times before: we're _NOT_ putting private
> ioctl^Hxattrs onto the wire. If the protocol can't be described in an
> RFC, then it isn't going in no matter what expletive you choose to
> use...

With the SGI supplied reference implementation it ought to be a
small matter of work to write an RFC. If the information weren't
SGI proprietary I could even tell you how long it ought to take
a junior engineer in Melbourne to write. The fact that there is
currently no RFC does not mean that there cannot be a RFC, only
that no one has written (or published) one yet.


Casey Schaufler
casey@schaufler-ca.com
