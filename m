Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYB2BFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYB2BFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271AbYB2Aud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:50:33 -0500
Received: from pat.uio.no ([129.240.10.15]:55022 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760481AbYB2Au1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:50:27 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080229003937.GA16343@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
	 <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229003937.GA16343@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:50:06 -0800
Message-Id: <1204246206.7363.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 7242691330AC17E181FBA9D44A0E9E947EAECA92
X-UiO-SR-test: C330EBE6F5987778147120841AEE4B95914EB241
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 144 total 7143547 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 19:39 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 07:04:57PM -0500, Dave Quigley wrote:
> > There are several things here. I've spoken to several people about this
> > and the belief I've gotten from most of them is that a recommended
> > attribute is how this is to be transported. The NFSv4 spec people will
> > probably say that if you want xattr like functionality for NFSv4 use
> > named attributes. For us this is not an option since we require
> > semantics to label on create/open and the only way we can do this is by
> > adding a recommended attribute. The create/open calls in NFSv4 takes a
> > list of attributes to use on create as part of the request. I really
> > don't see a difference between the security blob and the
> > username/groupname that NFSv4 currently uses. Also there is a good
> > chance that we will need to translate labels at some point (read future
> > work).
> 
> Then use the existing side-band protocol and ignore the NFSv4 spec
> group.  They're <skip colourful language here> anyway.

As I've told you several times before: we're _NOT_ putting private
ioctl^Hxattrs onto the wire. If the protocol can't be described in an
RFC, then it isn't going in no matter what expletive you choose to
use...

