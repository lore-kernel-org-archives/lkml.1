Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZFZWqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZFZWqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZFZWq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:46:28 -0400
Received: from mail.open.by ([193.232.92.17]:57842 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZWq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:46:27 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8849 [Jun 27 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sat, 27 Jun 2009 01:48:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626224802.GB3858@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
 <20090626065923.GA14078@elte.hu>
 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
 <20090626081452.GB3451@localdomain.by>
 <1246004270.27533.16.camel@penberg-laptop>
 <20090626085056.GC3451@localdomain.by>
 <1246032766.30717.44.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246032766.30717.44.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 17:12), Catalin Marinas wrote:
> I had a look at your patch and I tend to agree with Pekka. It really
> adds too much complexity for something that could be easily done in user
> space (could be more concise or even written in perl, awk, sed, python
> etc.):
> 
> cat /sys/kernel/debug/kmemleak | tr "\n" "#" \
> 	| sed -e "s/#unreferenced/\nunreferenced/g" \
> 	| grep -v "tty_ldisc_try_get" | tr "#" "\n"
> 
Well, it's hardly can be compared with 
echo "block=ADDRESS_FROM_STACK" > /.../kmemleak

Frankly, I still found it useful (as you don't have to write in perl, awk, sed, python etc 
to see 50 lines (you are interested in) out of 1000.
You just watching reports.)

(well, maybe not as useful as with syslog.)
 
Anyway, the decision is yours. And let it be so.
Thanks.

> Thanks anyway.
> 
> -- 
> Catalin
> 

	Sergey
