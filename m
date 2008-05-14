Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbYENRBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbYENRBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYENRAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:00:51 -0400
Received: from sous-sol.org ([216.99.217.87]:51841 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYENRAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:00:50 -0400
Date: Wed, 14 May 2008 09:58:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>, casey@schaufler-ca.com,
       lsm <linux-security-module@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
Message-ID: <20080514165842.GD17453@sequoia.sous-sol.org>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com> <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil> <20080514091526.GB17453@sequoia.sous-sol.org> <1210762984.6206.293.camel@moss-spartans.epoch.ncsc.mil> <20080514152817.GC17453@sequoia.sous-sol.org> <1210780216.28282.4.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210780216.28282.4.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Smalley (sds@tycho.nsa.gov) wrote:
> What do you mean by "generic" in the above?  Just the fact that there
> wouldn't be any distinction between such access and access to a
> descriptor received explicitly via local IPC from the target task?

Basically, yeah.

> Ok, so perhaps the only distinction that makes sense is read vs.
> write/control, with all checks within proc except mem_write using the
> former and ptrace_attach and mem_write using the latter?

Yeah, that's what I was wondering, because maps seems to fall into the
readstate category as much as fd/ does (probably fdinfo/ is closer to
maps).

thanks,
-chris
