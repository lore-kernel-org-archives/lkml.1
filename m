Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0CHTcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:32:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab0CHTcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:32:48 -0500
Date: Mon, 8 Mar 2010 11:32:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100308191749.19e20430@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003081125020.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <20100308184521.GK30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain> <20100308191749.19e20430@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Alan Cox wrote:
>
> Its path based in the sense that public_html has a path based meaning by
> convention understood by httpd. Copy a jpeg into your public_html and it
> will be labelled up for http access under the Fedora shipped rule sets.

Umm. That was my point all along: you can basically "emulate" pathname 
based decisions by labeling things. But it's not always the most direct 
approach, and some people clearly do find AppArmor (or Tomoyo, which I 
think is also largely based on pathnames) to be more "intuitive".

So I don't understand it when people then complain about a mechanism that 
base their decisions fundamentally on the pathname. It's not like AppArmor 
got rid of the traditional unix inode-based protections and replaced them 
(like your silly DEC10 example).

But whatever. The fact is, Ubuntu uses it. We'll merge it.

				Linus
