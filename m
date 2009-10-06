Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZJFAcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZJFAcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZJFAcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807AbZJFAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:32:20 -0400
Date: Mon, 5 Oct 2009 17:30:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Valdis.Kletnieks@vt.edu, Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>  <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Jeff Chua wrote:
> 
> Loud and clear. And appreciated all the replies. I think it's time for
> upgrade!

As Byron said, it really should be sufficient to just upgrade the kernel 
(I presume that you already have a CPU that is 64-bit capable: not very 
many boards with old CPU's can even fit 64GB of ram).

In fact, I wish more people did that, just so that we'd get better 
coverage of the 32-bit compat code. We occasionally find issues there, 
although I think it's getting rarer.

			Linus
