Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbYB2RIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbYB2RIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYB2RHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:07:53 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYB2RHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:07:52 -0500
Date: Fri, 29 Feb 2008 09:06:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Friesen <cfriesen@nortel.com>
cc: Pavel Roskin <proski@gnu.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <47C838C5.8030707@nortel.com>
Message-ID: <alpine.LFD.1.00.0802290905240.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <47C838C5.8030707@nortel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Chris Friesen wrote:
>
> But the GPL only applies to derivative works.  Given that ndiswrapper loads
> binaries designed for another OS, doesn't that mean that it is unlikely that
> the binaries would be impacted by the GPL?

But that's what GPLONLY means.

What's so hard to understand? The driver may not be a derivative work, but 
it sure as hell isn't GPL'd. 

So stop blathering. ndiswrapper has one purpose, and one purpose only: to 
load non-GPL'd code. So OF COURSE it shouldn't touch GPLONLY functions.

		Linus
