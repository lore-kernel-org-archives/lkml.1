Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYB2R0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYB2R0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYB2R02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:26:28 -0500
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:35052 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754625AbYB2R01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:26:27 -0500
X-YMail-OSG: ZdmpUjsVM1nAZrBRQVtaLKH.KM7RY2k.FNHeEiuq
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 09:26:25 -0800 (PST)
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
In-Reply-To: <1204261289.7213.12.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <200003.6173.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> ...
> > With the SGI supplied reference implementation it ought to be a
> > small matter of work to write an RFC. If the information weren't
> > SGI proprietary I could even tell you how long it ought to take
> > a junior engineer in Melbourne to write. The fact that there is
> > currently no RFC does not mean that there cannot be a RFC, only
> > that no one has written (or published) one yet.
> 
> NO! It is not a "small matter of work".

Ah, well, I don't understand why, but that's probably just
me being ignorant. It happens from time to time.

> The fact is that private crap like the 'security' and 'system' namespace
> makes describing 'xattr' as a protocol a non-starter and an
> interoperability nightmare.

Ok, I can buy that it doesn't fit in with the current protocol
mindset, and that I for one have not demonstrated that it can
be. I remember how upset the IETF got over the original CIPSO
proposal not specifying which label tag value coresponded to
"Top Secret". 

> If you can't do better than xattr for a
> security protocol, then it is time to go look for another job...

But ... I don't have a job. You're being mean. (smiley)

I think that we have a conflict between what works well for
a filesystem (xattrs are really helpful) and what works well
for a network protocol (undefined blobs of goo are atrocious)
in the case of a network file system. From either standpoint
the other is completely unworkable.

It may be the case that for NFS the proposed scheme (delta
LSM naming propriety, which is getting addressed) is the
best we can do. NFS is an old protocol (older than some of
the people reading this) and should be excused some shortcomings.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
