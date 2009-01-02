Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbZABWf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbZABWf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZABWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:35:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55314 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbZABWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:35:42 -0500
Date: Fri, 2 Jan 2009 23:37:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102223716.GC8843@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102175737.GA5818@uranus.ravnborg.org> <1230935253.15389.99.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230935253.15389.99.camel@pasglop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 09:27:33AM +1100, Benjamin Herrenschmidt wrote:
> 
> > 
> > Bugger....
> > Now I cannot do cross compile for: alpha, arm, m68k and sparc.
> > 
> > Not that I actually try to run these beasts but just being able
> > to do cross compile has served me well.
> > 
> > Last I looked (only few days ago) crosstool-ng did not support sparc :-(
> 
> There are also various variants of 4.1.1 around with the fix for
> that inline bug backported (I think that's the case of the compiler
> that ships with the Cell SDK for example).
> 

We could add a feature check during the early phase of the
kernel build so we know if gcc has this bug or not.

But this would be the first time to do so IIRC - today we only
do some limited check to see if certain options are supported.

	Sam
