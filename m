Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYB2RUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYB2RUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYB2RUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:20:13 -0500
Received: from c60.cesmail.net ([216.154.195.49]:54993 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYB2RUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:20:12 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 12:20:09 -0500
Message-Id: <1204305609.21719.16.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 09:07 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Zan Lynx wrote:
> > 
> > The Linux kernel itself will load proprietary modules.  It does not as a
> > general rule, but it will.
> 
> .. and it doesn't export GPLONLY modules to them.
> 
> How stupid do you have to be to not understand that?

Actually, it's a flawed comparison.  The only thing ndiswrapper exports
to NDIS modules is NDIS API.  GPLONLY symbols are only used to implement
that API in the code that's under GPL.  That's the code you can fork,
change and redistribute.

-- 
Regards,
Pavel Roskin
