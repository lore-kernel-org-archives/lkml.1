Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYB2FB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYB2FB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYB2FBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:01:51 -0500
Received: from pat.uio.no ([129.240.10.15]:43867 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYB2FBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:01:50 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <227831.22689.qm@web36606.mail.mud.yahoo.com>
References: <227831.22689.qm@web36606.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 21:01:29 -0800
Message-Id: <1204261289.7213.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: DC84A2FF5B143C33BDFD898AE2795AFCDCDB3BD3
X-UiO-SR-test: 126F1AC8C9B76B0E379EB0B1831631509AA564EF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 8 total 7144105 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 17:26 -0800, Casey Schaufler wrote:
> --- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > 
> > On Thu, 2008-02-28 at 19:39 -0500, Christoph Hellwig wrote:
> > > On Thu, Feb 28, 2008 at 07:04:57PM -0500, Dave Quigley wrote:
> > > > There are several things here. I've spoken to several people about this
> > > > and the belief I've gotten from most of them is that a recommended
> > > > attribute is how this is to be transported. The NFSv4 spec people will
> > > > probably say that if you want xattr like functionality for NFSv4 use
> > > > named attributes. For us this is not an option since we require
> > > > semantics to label on create/open and the only way we can do this is by
> > > > adding a recommended attribute. The create/open calls in NFSv4 takes a
> > > > list of attributes to use on create as part of the request. I really
> > > > don't see a difference between the security blob and the
> > > > username/groupname that NFSv4 currently uses. Also there is a good
> > > > chance that we will need to translate labels at some point (read future
> > > > work).
> > > 
> > > Then use the existing side-band protocol and ignore the NFSv4 spec
> > > group.  They're <skip colourful language here> anyway.
> > 
> > As I've told you several times before: we're _NOT_ putting private
> > ioctl^Hxattrs onto the wire. If the protocol can't be described in an
> > RFC, then it isn't going in no matter what expletive you choose to
> > use...
> 
> With the SGI supplied reference implementation it ought to be a
> small matter of work to write an RFC. If the information weren't
> SGI proprietary I could even tell you how long it ought to take
> a junior engineer in Melbourne to write. The fact that there is
> currently no RFC does not mean that there cannot be a RFC, only
> that no one has written (or published) one yet.

NO! It is not a "small matter of work".

The fact is that private crap like the 'security' and 'system' namespace
makes describing 'xattr' as a protocol a non-starter and an
interoperability nightmare. If you can't do better than xattr for a
security protocol, then it is time to go look for another job...

