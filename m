Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbYAOQJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbYAOQJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYAOQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:08:49 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:57663 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYAOQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:08:47 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Daniel J Walsh <dwalsh@redhat.com>, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <32507.1200412997@redhat.com>
References: <1200409002.9669.43.camel@moss-spartans.epoch.ncsc.mil>
	 <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <17868.1199897484@redhat.com>
	 <3466.1200319279@redhat.com>   <32507.1200412997@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 15 Jan 2008 11:08:09 -0500
Message-Id: <1200413289.9669.50.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 16:03 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > >  (3) Check that the kernel may create files as a particular secid (this
> > >      could be specified indirectly by specifying an inode, which would
> > >      hide the secid inside the LSM).
> > 
> > I don't think this check is on the kernel per se but rather the ability
> > of the daemon to nominate a secid for use on files created later by the
> > kernel module.
> 
> Hmmm...  At the moment the cachefiles module works out for itself what the
> file label should be by looking at the root directory it was given and
> assuming the label on that is what it's going to be using.  Are you suggesting
> this should be specified directly instead by the daemon?

No, just that however the secid is determined (whether indirectly via
specification of a directory or directly via specification of a secid),
the ability of the daemon to control what secid gets used ought to be
controlled.  Or, alternatively, the ability of the daemon to enable
caching in a given directory ought to be controlled.

-- 
Stephen Smalley
National Security Agency

