Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXHNRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXHNRrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXHNRrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:47:09 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:45616 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758026AbXHNRrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:47:07 -0400
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <861956.50630.qm@web36613.mail.mud.yahoo.com>
References: <861956.50630.qm@web36613.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Aug 2007 13:42:48 -0400
Message-Id: <1187113368.26008.226.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 08:53 -0700, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > > With Smack you can leave the label alone, raise CAP_MAC_OVERRIDE,
> > > do your business of setting the label correctly, and then drop
> > > the capability. No new hooks required.
> > 
> > That sounds like a contradiction.  How can you both leave it alone and set
> > it?
> 
> Whoops, sorry. You leave the process label alone and explicitly
> set the file label using the xattr interfaces.

xattr interfaces don't help with the initial labeling of the file when
it is created.

-- 
Stephen Smalley
National Security Agency

