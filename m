Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZF2KvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZF2KvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZF2KvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:51:03 -0400
Received: from mail.open.by ([193.232.92.17]:54084 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbZF2KvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:51:02 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8857 [Jun 29 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Mon, 29 Jun 2009 13:52:46 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemleak hexdump proposal
Message-ID: <20090629105246.GB3731@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
 <20090629101917.GA3093@localdomain.by>
 <1246270774.6364.9.camel@penberg-laptop>
 <1246271880.21450.13.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246271880.21450.13.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 11:38), Catalin Marinas wrote:
> On Mon, 2009-06-29 at 13:19 +0300, Pekka Enberg wrote:
> > On Mon, 2009-06-29 at 13:19 +0300, Sergey Senozhatsky wrote:
> > > Well, it's not easy to come up with something strong. 
> > > I agree, that stack gives you almost all you need.
> > > 
> > > HEX dump can give you a _tip_ in case you're not sure. 
> > 
> > Don't get me wrong, I'm not against it in any way. If Catalin is
> > interested in merging this kind of functionality, go for it! You might
> > want to consider unconditionally enabling the hexdump. If the
> > information is valuable, we should print it all the time.
> 
> Though I prefer to do as much as possible in user space, 
Agreed. Good example is 'function filtering' ;)

> I think this feature would be useful.
> 
So, I'll continue my work. (given patch didn't even passed ./checkpatch.pl).
Ok?

> Anyway, I may not include it before the next merging window (when is
> actually the best time for new features). Currently, my main focus is on
> reducing the false positives.
Sure. No problems.

> 
> -- 
> Catalin
> 

	Sergey
