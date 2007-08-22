Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbXHVG5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbXHVG5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXHVG53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:57:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56600 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbXHVG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:57:28 -0400
Message-ID: <46CBDD25.5050909@vmware.com>
Date: Tue, 21 Aug 2007 23:52:21 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix lazy mode vmalloc synchronization for paravirt
References: <46CB91BC.2010808@vmware.com> <46CBD78C.3020804@goop.org>
In-Reply-To: <46CBD78C.3020804@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> No, under Xen the kernel/hypervisor PMD is not shared between processes,
> so this is still used when PAE is enabled.
>   

Ahh, yes.  So this was a lucky catch for us.  Non-PAE kernels seem to be 
increasing in value at antique sales.

Zach

