Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYFDVuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYFDVuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbYFDVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:49:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50271
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762346AbYFDVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:49:51 -0400
Date: Wed, 04 Jun 2008 14:49:50 -0700 (PDT)
Message-Id: <20080604.144950.117343339.davem@davemloft.net>
To: joseph@codesourcery.com
Cc: galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk>
References: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
	<Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joseph S. Myers" <joseph@codesourcery.com>
Date: Wed, 4 Jun 2008 21:42:55 +0000 (UTC)

> On Wed, 4 Jun 2008, Kumar Gala wrote:
> 
> > I'm trying to move the powerpc math-emu
> > code to use the include/math-emu bits.
> 
> I'd like to remind people that the include/math-emu code is based on an 
> old, buggy version of the soft-fp code in glibc.  RTH previously noted 
> <http://sourceware.org/ml/libc-alpha/2006-02/msg00075.html> that the fixes 
> should go in the kernel, when approving a patch of mine fixing various 
> bugs and speeding up soft-fp, and several more bugs have been fixed since 
> then in the course of GCC work on soft-float for Power and __float128 
> support for x86_64.
> 
> So it may be better than the old code you're replacing, but it might still 
> be a good idea to merge things with the current glibc code, as a matter of 
> both correctness and performance.  (And there may well still be bugs left 
> in the code.)

Once the GCC folks started looking into using the soft-fp bits I knew
this situation would develop.  The kernel side would have some set of
fixes and the glibc/gcc side would have yet another set.

To be honest this doesn't surprise me...
