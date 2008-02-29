Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbYB2Tyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbYB2Tyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYB2Tyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:54:39 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYB2Tyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:54:39 -0500
Date: Fri, 29 Feb 2008 11:53:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Roskin <proski@gnu.org>
cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <1204313978.2316.8.camel@dv>
Message-ID: <alpine.LFD.1.00.0802291151460.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>  <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>  <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>  <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>  <1204304352.6767.21.camel@localhost>
  <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>  <1204305609.21719.16.camel@dv>  <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Pavel Roskin wrote:
> 
> I already know what USB folks will say.  They want proprietary drivers
> to be in the userspace.  I doubt ndiswrapper will ever be ported to the
> userspace.  It's much more likely that some other approach will be used.

If that's the case, then talk to the USB people. Maybe they are ok with 
wrapping them in GPL wrappers. But it sounds like they would prefer the 
stricter GPLONLY meaning (ie no ndiswrapper), and it's their code.

			Linus
