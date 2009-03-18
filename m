Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZCRQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZCRQ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758086AbZCRQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:58:50 -0400
Received: from mail.fieldses.org ([141.211.133.115]:59927 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbZCRQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:58:48 -0400
Date: Wed, 18 Mar 2009 12:57:30 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Igor Zhbanov <izh1979@gmail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
Subject: Re: =?utf-8?B?0J7RgtCy0LXRgjogVkZTLCBORlMg?=
	=?utf-8?Q?security_bug=3F_Shoul?=
	=?utf-8?Q?d?= CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
	CAP_FS_MASK?
Message-ID: <20090318165730.GA15084@fieldses.org>
References: <1237227705.1035.93.camel@localhost.localdomain> <20090316184926.GA6729@us.ibm.com> <1237237216.1035.195.camel@localhost.localdomain> <20090316231340.GC15522@us.ibm.com> <1237299633.6582.107.camel@localhost.localdomain> <20090317173903.GA31566@us.ibm.com> <1237312345.6582.140.camel@localhost.localdomain> <20090317182335.GB31633@us.ibm.com> <1237393287.12822.50.camel@localhost.localdomain> <20090318164712.GB27906@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318164712.GB27906@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 11:47:12AM -0500, Serge E. Hallyn wrote:
> Ok, thanks for time.  It's all pretty clear to me now:
> 
> CAP_MKNOD and CAP_LINUX_IMMUTABLE need to be added to the CAP_FS_MASK
> because, in 2.0 timeframe, fsuid==0 gave you those privileges.
> 
> xattrs didn't exist back then, so the setting of security.* and
> trusted.* xattrs doesn't need to be enabled by fsuid==0.  So really
> CAP_SETFCAP also doesn't need to be added to CAP_FS_MASK either.

Are we left with any simple one-sentence description of what CAP_FS_MASK
means?  (Other than just a particular list of bits?)  I'm just wondering
how additional bits will get decided in the future.

> I'll send out a patch later today for 2.6, unless Igor wants to
> do it (since he's the one who found this originally).

OK, apologies if I jumped the gun on the nfsd-specific patch--I lost
track of this discussion, thought it might take longer, and wanted to
get the one patch into 2.6.30.  Feel free to revert that, or ignore it
and leave it to me to revert it afterwards, as convenient....

--b.
