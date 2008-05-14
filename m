Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYENJPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYENJPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYENJPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:15:44 -0400
Received: from sous-sol.org ([216.99.217.87]:55254 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYENJPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:15:43 -0400
Date: Wed, 14 May 2008 02:15:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, lsm <linux-security-module@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
Message-ID: <20080514091526.GB17453@sequoia.sous-sol.org>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com> <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Smalley (sds@tycho.nsa.gov) wrote:
> As above, it isn't quite a read vs. readwrite mode distinction (which is
> why I called it ptrace_may_readstate rather than just ptrace_may_read),
> and the advantage of implementing it via a new interface is that we only
> need to update the callers where we want to apply this different
> checking, leaving all other callers unmodified and unaffected.  So while
> I could do it the way you describe, I'm not sure it would yield a better
> result.  Maybe others can chime in with their opinions.

It is slightly ad-hoc.  Is it just the audit messages that you described
that made you pick environ and fd, or was there more specific (threat
based) reasoning?  Would /proc/pid/fd/ + genfs + e.g. anonfd be a little
wider than just readstate?

Perhaps you could update the comments in ptrace_may_inspect() to clarify.

thanks,
-chris
