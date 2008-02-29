Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbYB2QJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbYB2QJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbYB2QJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:09:45 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbYB2QJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:09:45 -0500
Date: Fri, 29 Feb 2008 08:08:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Roskin <proski@gnu.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
Message-ID: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Pavel Roskin wrote:
> > 
> > I'm not seeing why ndiswrapper should be treated separately.
> 
> It is already treated separately, and has been for a long time.

No, I mean "separately from the thing it loads".

It loads non-GPL code, it is non-GPL.

> > If it loads non-GPL modules, it shouldn't be able to use GPLONLY symbols.
> 
> This is not the original intention of GPLONLY.  GPLONLY exists to prevent
> loading of modules that are proprietary, but can be considered to be Linux
> derivatives due to their use of Linux specific API.

Exactly. And ndiswrapper loads proprietary modules.

You're not following the argument. There was a reason ndiswrapper was 
marked for tainting. 

			Linus
