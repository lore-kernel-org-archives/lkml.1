Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbYB2U3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbYB2U3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYB2U2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:28:55 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbYB2U2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:28:55 -0500
Date: Fri, 29 Feb 2008 12:28:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Roskin <proski@gnu.org>
cc: Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <1204315713.2316.15.camel@dv>
Message-ID: <alpine.LFD.1.00.0802291224290.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>  <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>  <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>  <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>  <1204304352.6767.21.camel@localhost>
  <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>  <1204305609.21719.16.camel@dv>  <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>  <1204313978.2316.8.camel@dv>  <alpine.LFD.1.00.0802291151460.17889@woody.linux-foundation.org>
 <1204315713.2316.15.camel@dv>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Pavel Roskin wrote:
> 
> This still leaves us with the workqueue interface:
> 
> __create_workqueue_key
> destroy_workqueue
> flush_workqueue
> queue_work

Hmm. Personally, I don't see those as being a big issue, but they've been 
marked GPL-only for a long while. 

The thing is, I personally don't mind, and I think "derived code" is what 
matters, but others disagree, and quite frankly, I'm not going to force 
them - I have my _personal_ beliefs, but hey, others have theirs.

So you really need to talk to not me, but to the people who actually wrote 
and maintain that code. When they come back and say "yeah, we think 
ndiswrapper is a special case and we're ok with it", I'll happily either 
mark those things non-GPL or just mark ndiswrapper special in the module 
loader again.

Quite frankly, I don't care about ndiswrapper enough (at all) to push this 
along in the least. 

		Linus
