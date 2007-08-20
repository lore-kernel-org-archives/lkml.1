Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbXHTXPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbXHTXPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXHTXO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:14:58 -0400
Received: from ozlabs.org ([203.10.76.45]:34222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbXHTXO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:14:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18122.8295.69788.435555@cargo.ozlabs.ibm.com>
Date: Tue, 21 Aug 2007 09:14:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland McGrath <roland@redhat.com>
Cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [POWERPC] Fix for assembler -g
In-Reply-To: <20070820201818.A68C54D05F2@magilla.localdomain>
References: <20070820200856.GA4194@redhat.com>
	<20070820201818.A68C54D05F2@magilla.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath writes:

> Hmm.  Check the V=1 make output to see that the lparmap.c really got the -g0.
> The log says it didn't.  Oops!  It looks like the patch that got committed is
> the one that sets CFLAGS_lparmap.s, but really it needs to set
> CFLAGS_lparmap.o instead (go kbuild).  Did I post the wrong one?  (It's only
> one letter different.)  Sorry about that!  (I committed the right one to
> Fedora, which you'd think would help Dave, but no.)

Stephen Rothwell has posted a patch which makes this all moot by
eliminating the #include of the .s file.  I'm going to put that in my
tree shortly.

Paul.
