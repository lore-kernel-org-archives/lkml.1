Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXGWQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXGWQiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932565AbXGWQhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:37:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:43258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbXGWQhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:37:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 3/8] i386: bitops: Rectify bogus "+m" constraints
Date: Mon, 23 Jul 2007 18:37:27 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jh@suse.cz
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231837.27592.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 18:05:43 Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [3/8] i386: bitops: Rectify bogus "+m" constraints
> 
> From the gcc manual:
> 
>   Extended asm supports input-output or read-write operands. Use the
>   constraint character `+' to indicate such an operand and list it with
>   the output operands. You should only use read-write operands when the
>   constraints for the operand (or the operand in which only some of the
>   bits are to be changed) allow a register.
> 
> So, using the "+" constraint modifier for memory, like "+m" is bogus.
> We must simply specify "=m" which handles the case correctly.

I checked with Honza (cc'ed) and he stated that the + are really needed
at least in newer gcc.

-Andi
