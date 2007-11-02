Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbXKBB4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbXKBB4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXKBB4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:56:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:41375 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXKBB4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:56:08 -0400
Date: Thu, 1 Nov 2007 21:54:54 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
Message-ID: <20071102015453.GA7636@thunk.org>
Mail-Followup-To: tytso@mit.edu, "Serge E. Hallyn" <serue@us.ibm.com>,
	Stephen Smalley <sds@epoch.ncsc.mil>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-security-module@vger.kernel.org,
	Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>,
	Chris Wright <chrisw@sous-sol.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Natalie Protasevich <protasnb@gmail.com>
References: <20071031234945.GA16455@sergelap.austin.ibm.com> <1193918844.12018.6.camel@moss-spartans.epoch.ncsc.mil> <20071101134701.GA21131@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101134701.GA21131@sergelap.austin.ibm.com>
1;1609;0cFrom: Theodore Tso <tytso@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: Theodore Tso <tytso@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 08:47:01AM -0500, Serge E. Hallyn wrote:
> > > >From 5bff8967f45a35f858b96ca673d9bf98eac53d49 Mon Sep 17 00:00:00 2001
> > > From: Serge E. Hallyn <serue@us.ibm.com>
> > > Date: Wed, 31 Oct 2007 11:22:04 -0500
> > > Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2)

> New patch on top of previous one is appended.
> 
> From 98741f07ab1bc4a1fc2de7fedfb9023ea30bf988 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Thu, 1 Nov 2007 08:20:12 -0500
> Subject: [PATCH 1/1] file capabilities: remove the non-matching uid special case for kill
> 

Tested-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, this fixes the issue I reported!

				- Ted
