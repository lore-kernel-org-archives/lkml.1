Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXJEIGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXJEIGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 04:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXJEIFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 04:05:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:54553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbXJEIFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 04:05:48 -0400
From: Andi Kleen <ak@suse.de>
To: Keir Fraser <keir@xensource.com>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and pagetable setup/pulldown
Date: Fri, 5 Oct 2007 10:03:44 +0200
User-Agent: KMail/1.9.1
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <C32B9BEC.E711%keir@xensource.com>
In-Reply-To: <C32B9BEC.E711%keir@xensource.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051003.45129.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Fortuitously, Jan Beulich has a patch to fix this. It's not going to be
> directly applicable to 2.6.23-rc series, but should be easily ported:
> <http://lists.xensource.com/archives/html/xen-devel/2007-03/msg01200.html>.

Do I misread that patch or does it really walk the complete address
space and try to take all possible locks? Isn't that very slow?

-Andi
