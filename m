Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbYB2BJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbYB2BJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbYB2BAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:00:25 -0500
Received: from pat.uio.no ([129.240.10.15]:32797 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbYB2BAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:00:21 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080229005113.GA24087@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
	 <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229003937.GA16343@infradead.org>
	 <1204246206.7363.13.camel@heimdal.trondhjem.org>
	 <20080229005113.GA24087@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:00:05 -0800
Message-Id: <1204246805.7363.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: D547A02AA1BBC6AA53DB973EC2311A5D5FB72711
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 7143572 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 19:51 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 04:50:06PM -0800, Trond Myklebust wrote:
> > As I've told you several times before: we're _NOT_ putting private
> > ioctl^Hxattrs onto the wire. If the protocol can't be described in an
> > RFC, then it isn't going in no matter what expletive you choose to
> > use...
> 
> It's as unstructured as the named attributes already in.  Or file data
> for that matter.

Describing what is supposed to be a security mechanism in a structured
fashion for use in a protocol should hardly be an impossible task (and
AFAICS, Dave & co are making good progress in doing so). If it is, then
that casts serious doubt on the validity of the security model...

There should be no need for ioctls.

