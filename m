Return-Path: <linux-kernel-owner+w=401wt.eu-S933451AbZHDWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbZHDWdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbZHDWc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:32:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46362 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbZHDWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:32:59 -0400
Date: Tue, 4 Aug 2009 17:33:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and
	expired keys.
Message-ID: <20090804223301.GA16794@us.ibm.com>
References: <20090804210101.GB13499@us.ibm.com> <20090804184334.GC8442@us.ibm.com> <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145546.17676.98776.stgit@warthog.procyon.org.uk> <5007.1249417827@redhat.com> <25511.1249423252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25511.1249423252@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > This won't require keyring->sem?
> 
> Why should it?  A keyring merely points at a key, and if you follow this line
> of argument, then every keyring pointing at a key would have to be locked.

I see - so I could have the same dead key in 2 keyrings, recreate it in the
one ring, and it will be reactivated in both keyrings?

Ok, then that check (my original comment) is in fact needed :)

Thanks for indulging me.

-serge
