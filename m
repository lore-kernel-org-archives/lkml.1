Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbXJRDOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbXJRDOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXJRDN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:13:59 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:27278 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754820AbXJRDN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:13:58 -0400
X-YMail-OSG: caXr54kVM1lNn6uQyG.9e0pI6r65uPHb_NuWmsdaFUgzgTh0upjdWdc2hQ10xtGUHbsNw0yhgw--
X-RocketYMMF: rancidfat
Date: Wed, 17 Oct 2007 20:13:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
To: "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kaigai@kaigai.gr.jp,
       casey@schaufler-ca.com
In-Reply-To: <20071018025920.GA5067@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <884804.13501.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Tue, 16 Oct 2007 16:41:59 -0500
> > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > 
> > > To properly test this the libcap code will need to be updated first,
> > > which I'm looking at now...
> > 
> > This seems fairly significant.  I asusme that this patch won't break
> > presently-deployed libcap?
> 
> It will break libcap.  And I'm not sure of the right way to address it.
> So I was hoping to hear some ideas from Andrew Morgan, Chris Wright, and
> Kaigai.
> 
> We can introduce new capget64() and capset64() calls, and have
> capget() return -EINVAL or -EAGAIN if a high bit would be needed to
> accurately get the task's capabilities.
> 
> Or we can require a new libcap, since capget and capset aren't
> required for most day-to-day function anyway.
> 
> I guess now that I've written this out, it seems pretty clear
> that capget64() and capget64() are the way to go.  Any objections?

Not from me. Thank you.


Casey Schaufler
casey@schaufler-ca.com
