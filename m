Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXIFJ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXIFJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXIFJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:56:57 -0400
Received: from gw.goop.org ([64.81.55.164]:38632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbXIFJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:56:56 -0400
Message-ID: <46DFCEE3.8010903@goop.org>
Date: Thu, 06 Sep 2007 10:56:51 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <1189024666.10802.197.camel@localhost.localdomain> <1189036175.21516.31.camel@bodhitayantram.eng.vmware.com> <200709060641.36855.ak@suse.de>
In-Reply-To: <200709060641.36855.ak@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> ; it does
>> seem perfectly acceptable though for the mm code to use kmap or vmap
>> (not kmap_atomic) internally somewhere in the pagetable code.
>>     
>
> i386 does it all the time for highmem pagetables in fact.
>   

Yes, it uses kmap_atomic(_pte) all the time.  Is that what you meant?

    J
