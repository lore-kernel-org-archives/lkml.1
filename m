Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYGJIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYGJIrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYGJIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:47:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYGJIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:47:16 -0400
Date: Thu, 10 Jul 2008 01:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25.8] "kswapd0: page allocation failure. order:3" in
 tcp_collapse
Message-Id: <20080710014143.e5d8c642.akpm@linux-foundation.org>
In-Reply-To: <486AB006.7080808@imap.cc>
References: <486AB006.7080808@imap.cc>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 00:30:30 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> My Intel Pentium D940 system, Intel DQ965GF mainboard, 2 GB RAM, running an
> x86_32 build of kernel release 2.6.25.8 with openSUSE 10.3 userland, produced
> the message in the subject accompanied by a stack backtrace, seven times in a
> row within a few milliseconds, during the nightly backup of a Windows system
> through Bacula over the LAN. The backup did not report an error, though, and
> everything else seems to be running normally, too.
> 
> The kernel is built with CONFIG_SLUB=y.
> 
> ...
> 
> Should I worry? File a bug? Post more details? 

e1000 driver has a lovely habit of allocating 32k of GFP_ATOMIC memory for
packets which are a quarter that size.  AFAIK it is unfixable.  It is a
well-known and oft-reported problem.  The system should recover OK.

> Just ignore it?

Learn to enjoy it ;)
