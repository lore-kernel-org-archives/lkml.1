Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZF2LGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZF2LGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZF2LG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:06:29 -0400
Received: from mail.open.by ([193.232.92.17]:57650 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZF2LG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:06:28 -0400
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
Date: Mon, 29 Jun 2009 14:08:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemleak hexdump proposal
Message-ID: <20090629110812.GC3731@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
 <20090629101917.GA3093@localdomain.by>
 <1246270774.6364.9.camel@penberg-laptop>
 <20090629104553.GA3731@localdomain.by>
 <1246273108.21450.19.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246273108.21450.19.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 11:58), Catalin Marinas wrote:
> On Mon, 2009-06-29 at 13:45 +0300, Sergey Senozhatsky wrote:
> > BTW, printing it all the time we can spam kmemleak (in case there are objects sized 2K, 4K and so on).
> > That's why I wrote about hexdump=OBJECT_POINTER.
> 
> I'm more in favour of an on/off hexdump feature (maybe even permanently
> on) and with a limit to the number of bytes it displays. For larger
> blocks, the hexdump=OBJECT_POINTER is easily achievable in user space
> via /dev/kmem.
> 
Yeah. Good point.

> My proposal is for an always on hexdump but with no more than 2-3 lines
> of hex values. 
I like it.

> As Pekka said, I should get it into linux-next before the
> next merging window.
I'll send new patch to you (today evening)/(tomorrow). 
Ok?

> 
> -- 
> Catalin
> 

	Sergey
