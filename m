Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXKAURN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXKAURN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXKAUQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:16:56 -0400
Received: from THUNK.ORG ([69.25.196.29]:54968 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbXKAUQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:16:54 -0400
Date: Thu, 1 Nov 2007 16:12:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
Message-ID: <20071101201235.GF2387@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Serge E. Hallyn" <serue@us.ibm.com>,
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
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 08:47:01AM -0500, Serge E. Hallyn wrote:
> Egads.  I knew I should've just kept that part out of it for the first
> patch...
> 
> New patch on top of previous one is appended.

I assume you'll just collapse the two patches together before you
submit them?  I've been distracted dealing with the ALPM suspend2ram
regression, which Jeff Garzik beat me to in bisecting, but I'll try
out your newer patch now...

						- Ted
