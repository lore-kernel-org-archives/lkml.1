Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbYB2VOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbYB2VOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761449AbYB2VNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:13:37 -0500
Received: from c60.cesmail.net ([216.154.195.49]:16466 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761161AbYB2VNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:13:36 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.1.00.0802291224290.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv>
	 <alpine.LFD.1.00.0802291151460.17889@woody.linux-foundation.org>
	 <1204315713.2316.15.camel@dv>
	 <alpine.LFD.1.00.0802291224290.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:13:34 -0500
Message-Id: <1204319614.2316.39.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 12:28 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Pavel Roskin wrote:
> > 
> > This still leaves us with the workqueue interface:
> > 
> > __create_workqueue_key
> > destroy_workqueue
> > flush_workqueue
> > queue_work
> 
> Hmm. Personally, I don't see those as being a big issue, but they've been 
> marked GPL-only for a long while. 
> 
> The thing is, I personally don't mind, and I think "derived code" is what 
> matters, but others disagree, and quite frankly, I'm not going to force 
> them - I have my _personal_ beliefs, but hey, others have theirs.
>
> So you really need to talk to not me, but to the people who actually wrote 
> and maintain that code.

As far as I can tell, those people have never tried to prevent
ndiswrapper from using their code.  Both times ndiswrapper was prevented
from using GPLONLY symbols, it was done unintentionally.

> When they come back and say "yeah, we think 
> ndiswrapper is a special case and we're ok with it", I'll happily either 
> mark those things non-GPL or just mark ndiswrapper special in the module 
> loader again.

OK, I'll keep it in mind in case such approach actually becomes
necessary.

-- 
Regards,
Pavel Roskin
