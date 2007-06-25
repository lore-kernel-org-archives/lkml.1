Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXFYDha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXFYDha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXFYDhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:37:20 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:27787 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752953AbXFYDhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:37:18 -0400
X-YMail-OSG: pq2TMNAVM1kkIu3IHVCPPkHuVfyQZZvD4fLLWQN6YkM4DBB4f9PD.a4DkCf8NhkntGz_g7Hy7w--
X-RocketYMMF: rancidfat
Date: Sun, 24 Jun 2007 20:37:17 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
To: Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <20070625013944.GD3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <928208.47508.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Wright <chrisw@sous-sol.org> wrote:

> * Casey Schaufler (casey@schaufler-ca.com) wrote:
> > So, for planning purposes, when ought I expect to have to start
> > dealing with this?
> 
> What is your specific concern or use case?

Just hoping to avoid a change collision. If I have to deal
with this today it's easy, if it doesn't show up anywhere
until 2.6.28 I'm breezing, but if it all hits in two weeks I
have some scrambling and yet another delay to deal with. Not
your problem, a little information would be helpful though.

BTW, I reviewed my notes from the early days of LSM and it
turns out that I agree with the notion that loadable modules
don't make a whole lot of sense. So long as I can choose
security models as easily as I can change file systems, I'm
reasonably happy. That, and that the "default" "regular"
policy isn't too terribly different from the traditional
Unix policy.


Casey Schaufler
casey@schaufler-ca.com
