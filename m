Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXLCQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXLCQx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXLCQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:53:48 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40609 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbXLCQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:53:47 -0500
Date: Mon, 3 Dec 2007 11:53:47 -0500
To: Avi Kivity <avi@argo.co.il>
Cc: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203165347.GJ2308@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <4751BD23.7020104@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4751BD23.7020104@argo.co.il>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 09:59:31PM +0200, Avi Kivity wrote:
> C also requires a (very minimal) runtime. And I don't see how having a 
> runtime disqualifies a language from being usable in a kernel; the 
> runtime is just one more library, either supplied by the compiler or by 
> the kernel.

Well the majority of C syntax requires no runtime library.  There are
some system call like things that you often want that need a library
(like malloc and such), but those aren't really part of C itself.  Of
course without malloc and printf and file i/o calls the program would
probably be a bit boring.  I have written some small C programs without
a runtime, where the few things I needed where implemented in assembly
and poked the hardware directly and called from the C program.

> Object orientation in C leaves much to be desired; see the huge number 
> of void pointers and container_of()s in the kernel.

As a programming language, C leaves much to be desired.

--
Len Sorensen
