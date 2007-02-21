Return-Path: <linux-kernel-owner+w=401wt.eu-S1423195AbXBUWVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423195AbXBUWVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423200AbXBUWVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:21:01 -0500
Received: from gw.goop.org ([64.81.55.164]:55446 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423195AbXBUWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:21:00 -0500
Message-ID: <45DCC5C8.4090905@goop.org>
Date: Wed, 21 Feb 2007 14:20:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.osdl.org, Chris Wright <chrisw@sous-sol.org>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/24] Xen-paravirt_ops: Add pagetable accessors to pack
 and unpack pagetable entries
References: <20070221205254.169835700@goop.org> <20070221205322.869165491@goop.org> <200702212315.12883.ak@suse.de>
In-Reply-To: <200702212315.12883.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Do you have some lmbench numbers before/after this change? 
> iirc at least fork and exit do a lot of pte accesses in various forms.
> If it's measurable it might be needed to patch those for the native case.
>   

I don't.  I think Rusty ran some numbers and found the pte accessors
became the most commonly used paravirt ops.

I'm working on revamping the pv_ops patching infrastructure at the
moment, so we should be able to deal with these fairly efficiently.

    J
