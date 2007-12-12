Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbXLLTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbXLLTg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbXLLTgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:36:47 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:54103 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843AbXLLTgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:36:46 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <66139.71689.qm@web36604.mail.mud.yahoo.com>
References: <66139.71689.qm@web36604.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 12 Dec 2007 14:35:08 -0500
Message-Id: <1197488108.1125.141.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 11:20 -0800, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > > You may need to have an application, say cachefileselinuxcontext, that will
> > > read the current policy and spit out an appropriate value of "<whatever>",
> > > but that can be separate and LSM specific without mucking up your basic
> > > infrastructure applications.
> > 
> > What would I do with such a thing?  How would it get run?  Spat out to where?
> 
> Put it in /etc/init.d/cachefiles and run it at boot time. Put the
> result into /etc/cachefiles.conf. Have cachefilesd read it and pass
> it downward.

More likely, run it at build time in your .spec file to generate
cachefiles.conf, then run it again maybe upon a policy update or if the
user selects a different policy.

-- 
Stephen Smalley
National Security Agency

