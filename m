Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYB2RfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYB2RfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYB2Rez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:34:55 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbYB2Rez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:34:55 -0500
Date: Fri, 29 Feb 2008 09:33:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Roskin <proski@gnu.org>
cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <1204305609.21719.16.camel@dv>
Message-ID: <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>  <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>  <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>  <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>  <1204304352.6767.21.camel@localhost>
  <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Pavel Roskin wrote:
> 
> Actually, it's a flawed comparison.  The only thing ndiswrapper exports
> to NDIS modules is NDIS API.  GPLONLY symbols are only used to implement
> that API in the code that's under GPL.  That's the code you can fork,
> change and redistribute.

.. and it's stuill just a wrapper.

A fairly thick one, but still...

More importantly, none of the people arguing against this at all even 
reacted to my suggestion for how to fix things *properly* in my original 
email. Which just means that you're apparently not interested in actually 
fixing this, you're just trying to disagree about some interpretation of 
GPLONLY.

In other words: the next person who can't even be bothered to tell what 
symbols are involved and why they haven't asked whether those symbols 
could instead be relaxed, automaticaly will go into my "flamers" filter, 
and just stay there. Then you can complain as much as you like, and I'll 
never see it.

		Linus
