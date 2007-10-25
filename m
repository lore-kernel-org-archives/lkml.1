Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbXJYDuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbXJYDuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXJYDuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:50:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXJYDuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:50:07 -0400
Date: Wed, 24 Oct 2007 20:46:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
Message-ID: <20071024204631.7e7e3c47@laptopd505.fenrus.org>
In-Reply-To: <200710251324.49888.nickpiggin@yahoo.com.au>
References: <200710251324.49888.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 13:24:49 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Hi,
> 
> Andi spotted this exchange on the gcc list. I don't think he's
> brought it up here yet, but it worries me enough that I'd like
> to discuss it.
> 
> Starts here
> http://gcc.gnu.org/ml/gcc/2007-10/msg00266.html
> 
> Concrete example here
> http://gcc.gnu.org/ml/gcc/2007-10/msg00275.html
> 
> Basically, what the gcc developers are saying is that gcc is
> free to load and store to any memory location, so long as it
> behaves as if the instructions were executed in sequence.
> 


this optimization btw is a serious mis-optimization, it makes memory
more dirty and causes cachelines to become unshared.... I'm sure it
works great on microbenchmarks but it sucks bigtime for anything real
