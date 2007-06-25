Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXFYOYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXFYOYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXFYOYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:24:24 -0400
Received: from [80.68.207.6] ([80.68.207.6]:50345 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615AbXFYOYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:24:23 -0400
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: casey@schaufler-ca.com
Cc: Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <928208.47508.qm@web36606.mail.mud.yahoo.com>
References: <928208.47508.qm@web36606.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: UnBit
Date: Mon, 25 Jun 2007 16:24:23 +0200
Message-Id: <1182781463.5589.79.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno dom, 24/06/2007 alle 20.37 -0700, Casey Schaufler ha scritto:
> --- Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > * Casey Schaufler (casey@schaufler-ca.com) wrote:
> > > So, for planning purposes, when ought I expect to have to start
> > > dealing with this?
> > 
> > What is your specific concern or use case?
> 
> Just hoping to avoid a change collision. If I have to deal
> with this today it's easy, if it doesn't show up anywhere
> until 2.6.28 I'm breezing, but if it all hits in two weeks I
> have some scrambling and yet another delay to deal with. Not
> your problem, a little information would be helpful though.

I think you will not have too much problem with this patch.
After all, you will only need to remove a couple of functions (for the
unloading) and take rid of 'old' module parameters (if you use it)



-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

