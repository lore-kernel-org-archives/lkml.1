Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYFDVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYFDVtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbYFDVtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:49:40 -0400
Received: from mail.codesourcery.com ([65.74.133.4]:56957 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225AbYFDVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:49:39 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 17:49:39 EDT
Date: Wed, 4 Jun 2008 21:42:55 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Kumar Gala <galak@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>,
       lkml List <linux-kernel@vger.kernel.org>, libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
In-Reply-To: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk>
References: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Kumar Gala wrote:

> I'm trying to move the powerpc math-emu
> code to use the include/math-emu bits.

I'd like to remind people that the include/math-emu code is based on an 
old, buggy version of the soft-fp code in glibc.  RTH previously noted 
<http://sourceware.org/ml/libc-alpha/2006-02/msg00075.html> that the fixes 
should go in the kernel, when approving a patch of mine fixing various 
bugs and speeding up soft-fp, and several more bugs have been fixed since 
then in the course of GCC work on soft-float for Power and __float128 
support for x86_64.

So it may be better than the old code you're replacing, but it might still 
be a good idea to merge things with the current glibc code, as a matter of 
both correctness and performance.  (And there may well still be bugs left 
in the code.)

-- 
Joseph S. Myers
joseph@codesourcery.com
