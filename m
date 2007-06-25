Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXFYD6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXFYD6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXFYD6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:58:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56714 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbXFYD57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:57:59 -0400
Date: Sun, 24 Jun 2007 20:57:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
Message-ID: <20070625035733.GF3723@sequoia.sous-sol.org>
References: <20070625013944.GD3723@sequoia.sous-sol.org> <928208.47508.qm@web36606.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928208.47508.qm@web36606.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> Just hoping to avoid a change collision. If I have to deal
> with this today it's easy, if it doesn't show up anywhere
> until 2.6.28 I'm breezing, but if it all hits in two weeks I
> have some scrambling and yet another delay to deal with. Not
> your problem, a little information would be helpful though.

Assuming no issues, 2.6.23 (which is months away, although
merge window isn't).

> BTW, I reviewed my notes from the early days of LSM and it
> turns out that I agree with the notion that loadable modules
> don't make a whole lot of sense. So long as I can choose
> security models as easily as I can change file systems, I'm
> reasonably happy. That, and that the "default" "regular"
> policy isn't too terribly different from the traditional
> Unix policy.

The default will continue to be capabilities.

thanks,
-chris
