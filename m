Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZFZINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZFZINk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFZINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:13:25 -0400
Received: from mail.open.by ([193.232.92.17]:58264 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZFZINY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:13:24 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8838 [Jun 25 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Fri, 26 Jun 2009 11:14:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626081452.GB3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
 <20090626065923.GA14078@elte.hu>
 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 10:07), Pekka Enberg wrote:
> > This is not acceptable.
> >
> > Instead it should perhaps print _at most_ a single line every few
> > minutes, printing a summary about _how many_ leaked entries it
> > suspects, and should offer a /debug/mm/kmemleak style of file where
> > the entries can be read out from.
> 
> Yup, makes tons of sense.
> 
>                                      Pekka
> 

Hello Pekka,
What do you about suggested ability to filter/block "unwanted" reports?
IMHO it makes sense.

	Sergey
