Return-Path: <linux-kernel-owner+w=401wt.eu-S966006AbXG3CS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966006AbXG3CS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXG3CSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:18:50 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:4906 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764014AbXG3CSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:18:49 -0400
Date: Mon, 30 Jul 2007 03:18:42 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: Ollie Wild <aaw@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [SPARC32] NULL pointer derefference
Message-ID: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Unfortunatly Sparc32 sun4c low level memory management apears to be 
incompatible with commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
mm: variable length argument support.

For some reason, this commit corrupts the memory used by the low level 
context/pte handling ring buffers in arch/sparc/mm/sun4c (in 
add_ring_ordered, head->next becomes set to a NULL pointer).

I had a quick look at http://www.linux-mm.org to see if there were any 
diagrams that show what is going on in the memory management systems, to 
see if there was something that I could use to help me work out what is 
going on, but I could not see any.

Can any one help?

Regards
 	Mark Fortescue.
