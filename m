Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXIFFmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXIFFmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXIFFmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:42:45 -0400
Received: from mx1.suse.de ([195.135.220.2]:55721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbXIFFmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:42:45 -0400
From: Andi Kleen <ak@suse.de>
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
Date: Thu, 6 Sep 2007 06:41:36 +0100
User-Agent: KMail/1.9.1
Cc: Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <46CE70C8.2030005@vmware.com> <1189024666.10802.197.camel@localhost.localdomain> <1189036175.21516.31.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1189036175.21516.31.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709060641.36855.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I agree.  The patch is a nop.  I just got overly paranoid.  The whole
>thing is just very prone to bugs.
So do we need a patch for .23 or not?

>; it does
> seem perfectly acceptable though for the mm code to use kmap or vmap
> (not kmap_atomic) internally somewhere in the pagetable code.

i386 does it all the time for highmem pagetables in fact.

-Andi
