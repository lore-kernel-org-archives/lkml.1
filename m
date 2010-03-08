Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0CHTQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:16:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab0CHTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:16:16 -0500
Date: Mon, 8 Mar 2010 11:15:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003081107200.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <20100308184521.GK30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Linus Torvalds wrote:
> 
> Sure, there is content security. Nobody disputes that. The security 
> decision about how to open a file is about the contents of the file.

Btw, I would also say that content security is generally the _common_ 
case. So I'm not at all saying that the traditional unix model or the 
selinux model is in any way "wrong". Not at all.

It's just that I certainly understand why some people think AppArmor is 
more "intuitive". And I think it's directly related to the fact that 
sometimes the pathname-based approach is the one that more directly 
reflects the particular issue (and people are often happy with the 
traditional UNIX semantics for plain inode-based security, so again, it's 
not like AppArmor _replaces_ inode-based security, it _extends_ on it).

			Linus


