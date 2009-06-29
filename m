Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZF2KoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZF2KoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZF2KoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:44:14 -0400
Received: from mail.open.by ([193.232.92.17]:63463 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZF2KoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:44:13 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000003
X-SpamTest-Info: Profiles 8857 [Jun 29 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
X-SpamTest-Group-ID: 00000000
Date: Mon, 29 Jun 2009 13:45:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemleak hexdump proposal
Message-ID: <20090629104553.GA3731@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
 <20090629101917.GA3093@localdomain.by>
 <1246270774.6364.9.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246270774.6364.9.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 13:19), Pekka Enberg wrote:
> Hi Sergey,
> 
> On Mon, 2009-06-29 at 13:19 +0300, Sergey Senozhatsky wrote:
> > Well, it's not easy to come up with something strong. 
> > I agree, that stack gives you almost all you need.
> > 
> > HEX dump can give you a _tip_ in case you're not sure. 
> 
> Don't get me wrong, I'm not against it in any way. 
I don't think so ;) _IF_ even so - it's absolutely normal, to my mind.

> If Catalin is interested in merging this kind of 
> functionality, go for it! You might want to consider unconditionally
> enabling the hexdump. If the information is valuable, we should print
> it all the time.
I guess it's valuable enougth to print it, but not valuable enougth to print it all the time.
So, let me say - it's valuable enougth to print 'on demand', I guess. (I may be wrong).

BTW, printing it all the time we can spam kmemleak (in case there are objects sized 2K, 4K and so on).
That's why I wrote about hexdump=OBJECT_POINTER.

>
> 			Pekka
> 

	Sergey
