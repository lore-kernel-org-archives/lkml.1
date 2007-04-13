Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXDMB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXDMB0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXDMB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:26:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXDMB0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:26:30 -0400
Message-ID: <461EDBF1.4080904@zytor.com>
Date: Thu, 12 Apr 2007 18:25:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
References: <200704120530.l3C5UGbv022814@zach-dev.vmware.com>
In-Reply-To: <200704120530.l3C5UGbv022814@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Some PTE optimizations for native and paravirt-ops kernels; this
> provides a huge win for shadow mode hypervisors and gets rid of
> some unnecessary atomic instructions in native kernels, saving
> even more on UP by getting rid of implicit LOCK on xchg instruction.

You do know that P6 and higher don't do locked bus references as long as 
the value is in the cache, right?

	-hpa
