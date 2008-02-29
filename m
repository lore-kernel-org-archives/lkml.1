Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYB2Rq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYB2Rq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYB2RqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:46:17 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:21711 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755775AbYB2RqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:46:16 -0500
X-YMail-OSG: XpnUehgVM1m22cdDc2jYa0RwQUzjHmErYAelI_Udh_tENwnxQJTe79rZ9z3nJUACE3IpYehxIA--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 09:46:14 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Trond Myklebust <trond.myklebust@fys.uio.no>, casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204261491.7213.16.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <856298.92497.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Thu, 2008-02-28 at 17:55 -0800, Casey Schaufler wrote:
> 
> > > There should be no need for ioctls.
> > 
> > Sorry, but as far as I'm concerned you just threw a bunny under
> > the train for no apparent reason. What have ioctls got to do with
> > anything?
> 
> What part of 'interoperability' don't you get here?

I can understand that an implementation of NFS+xattr could
present some issues where only one side speaks the xattr
protocols, or where they speak them differently. If that's
a showstopper from the network protocol side (it isn't from
the file system end, client or server) then you're right,
it won't work. What I don't understand is why it would be
a showstopper. The current NFS protocol makes all sorts of
assumptions about the data it passes (like the uids on the
two ends mapping sanely) that seem to me to be as much a
problem as xattr value mapping.

> There is no room for extensions that allow clients+servers to establish
> arbitrary private protocols.

I think that I understand that you believe that, what I
don't understand is why you believe that. Is it an artifact
of the locking protocol that only worked about half the
time, and then in a half donkied way?

I'm not trying to be an obstructionist idiot here, even if
that's how it may appear. I have my pet solution, I really
don't see the problem with it, and it looks to me like the
arguements against it are either so obvious I'm missing them
(does happen) or based on dogmas I don't subscribe to.

Thank you for helping me (and maybe some others) understand
the issues we're up against so that I (we) can address issues
better in the future.


Casey Schaufler
casey@schaufler-ca.com
