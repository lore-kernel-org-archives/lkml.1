Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbXLMPif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbXLMPif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbXLMPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:38:11 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:61244 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762171AbXLMPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:38:09 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <715.1197500109@redhat.com>
References: <1197488108.1125.141.camel@moss-spartans.epoch.ncsc.mil>
	 <66139.71689.qm@web36604.mail.mud.yahoo.com>  <715.1197500109@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 13 Dec 2007 09:51:01 -0500
Message-Id: <1197557461.20226.24.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 22:55 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > More likely, run it at build time in your .spec file to generate
> > cachefiles.conf,
> 
> I don't think sticking it in cachefiles.conf is a good idea necessarily.
> That has to be an administrator modifiable file.  Is there a program I could
> make cachefiles run directly and capture the output of that could give me the
> info I want?

Yes, we could easily make a simple program that just invokes a
libselinux function that in turn grabs the proper context from some
context configuration file under /etc/selinux/$SELINUXTYPE/contexts/ and
outputs it.  Dan can help with that.

> > then run it again maybe upon a policy update or if the user selects a
> > different policy.
> 
> How do I do that?

-- 
Stephen Smalley
National Security Agency

