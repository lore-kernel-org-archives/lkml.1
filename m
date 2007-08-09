Return-Path: <linux-kernel-owner+w=401wt.eu-S941000AbXHIRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941000AbXHIRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937916AbXHIRZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:25:07 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:41347 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765488AbXHIRZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:25:05 -0400
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
	obtained [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <162335.27499.qm@web36605.mail.mud.yahoo.com>
References: <162335.27499.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Aug 2007 13:22:04 -0400
Message-Id: <1186680124.6916.624.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 10:07 -0700, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Permit an inode's security ID to be obtained by the CacheFiles module.  This
> > is
> > then used as the SID with which files and directories will be created in the
> > cache.
> 
> This is SELinux specific functionality. It should not be an LSM
> interface. 

Odd, you proposed exactly the same hook (aside from naming convention
and secid as argument vs. as retval) in recent postings on linux-audit
and selinux list for use by the audit system.

-- 
Stephen Smalley
National Security Agency

