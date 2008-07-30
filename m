Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYG3Bhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYG3Bhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYG3BhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:37:01 -0400
Received: from ozlabs.org ([203.10.76.45]:49273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYG3BhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:37:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc git pull] cpus4096 fixes, take 2
Date: Wed, 30 Jul 2008 10:15:38 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20080727190601.GA764@elte.hu> <200807291145.20231.rusty@rustcorp.com.au> <20080729121156.GA367@elte.hu>
In-Reply-To: <20080729121156.GA367@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807301015.39525.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 22:11:56 Ingo Molnar wrote:
> But gcc 3.4.5 apparently craps out on this valid use of a gcc extension,
> see the report and the fix at:

Hmm.  I can't find anything in the docs, but I'd assumed that a statement 
expression isn't an lvalue.  Trying "int x; &({ x; });" fails as expected 
with gcc 3.4, 4.1, 4.2 and 4.3:

	foo.c:3: error: lvalue required as unary ‘&’ operand

I'd say your code should, too...

Cheers,
Rusty.
