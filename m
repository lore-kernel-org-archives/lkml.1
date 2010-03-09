Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0CID7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:59:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932243Ab0CID7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:59:36 -0500
Date: Mon, 8 Mar 2010 19:58:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <4B95BFF6.5060503@schaufler-ca.com>
Message-ID: <alpine.LFD.2.00.1003081955010.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain> <4B958D7F.1030900@redhat.com> <alpine.LFD.2.00.1003081555480.3669@localhost.localdomain> <4B95BFF6.5060503@schaufler-ca.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Casey Schaufler wrote:
> 
> Those of you who say we ought to come up with a single framework
> that we can use to Do The Right Thing haven't been reading the code.
> We have such a framework in the LSM.

.. and people are also interested in using (and expanding) the 'notify' 
layer, probably because it is obviously designed for efficiently talking 
at a user-level program about the relevant accesses. Whether that is 
because they are just crazy ("malware detection") or whether it is an 
indication that the LSM layer and current security models are just not 
convenient enough, I dunno.

And whether all that has anything to do with "Do The Rigth Thing" is 
obviously very much unclear, but the interest is clearly there.

			Linus
