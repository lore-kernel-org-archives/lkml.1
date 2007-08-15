Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXHOQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXHOQbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXHOQaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:30:46 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:38195 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933166AbXHOQao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:30:44 -0400
X-YMail-OSG: pAJlxpEVM1ng9Qb0IC7alYni1XFI.LGrybYuBDzwtabBdz60DTOcqbOJSkd5_XT1fTVrCKPoZw--
X-RocketYMMF: rancidfat
Date: Wed, 15 Aug 2007 09:30:42 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1187113368.26008.226.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <18318.47287.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Tue, 2007-08-14 at 08:53 -0700, Casey Schaufler wrote:
> > --- David Howells <dhowells@redhat.com> wrote:
> > 
> > > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > 
> > > > With Smack you can leave the label alone, raise CAP_MAC_OVERRIDE,
> > > > do your business of setting the label correctly, and then drop
> > > > the capability. No new hooks required.
> > > 
> > > That sounds like a contradiction.  How can you both leave it alone and
> set
> > > it?
> > 
> > Whoops, sorry. You leave the process label alone and explicitly
> > set the file label using the xattr interfaces.
> 
> xattr interfaces don't help with the initial labeling of the file when
> it is created.

That's true. The deamon needs to run with an appropriate label.
I don't believe that this is situation with a really simple solution
because the activity being performed is unusual. 
 
> -- 
> Stephen Smalley
> National Security Agency
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
