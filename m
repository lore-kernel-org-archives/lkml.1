Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXBPQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXBPQqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXBPQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:46:45 -0500
Received: from gw.goop.org ([64.81.55.164]:46140 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXBPQqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:46:45 -0500
Message-ID: <45D5DFF3.6040005@goop.org>
Date: Fri, 16 Feb 2007 08:46:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
References: <20070216022449.739760547@goop.org> <20070216022531.417300365@goop.org> <20070215224322.5c73d8e9.akpm@linux-foundation.org> <45D55852.9000103@goop.org> <20070215232447.5ee67f50.akpm@linux-foundation.org> <45D55DB1.7040002@goop.org> <20070216091843.GB28196@muc.de>
In-Reply-To: <20070216091843.GB28196@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It's for populating the pagetable in a vmalloc area.  There's magic in
>>     
>
> If the lazy setup doesn't work for you you can always call vmalloc_sync()
> early.
>   

Yes, that would work.  Unfortunately that's i386 arch-specific, whereas
the rest of this code is generic.  I guess I could just move it all to
arch/i386/mm.

    J
