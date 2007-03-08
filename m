Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXCHSoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXCHSoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXCHSoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:44:46 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56982 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030AbXCHSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:44:43 -0500
Message-ID: <45F05999.20803@vmware.com>
Date: Thu, 08 Mar 2007 10:44:41 -0800
From: Daniel Arai <arai@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050920
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: tglx@linutronix.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org>
In-Reply-To: <20070308182456.GH19575@sequoia.sous-sol.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Daniel Arai (arai@vmware.com) wrote:
> 
>>There's no good way to override __send_IPI_shortcut.  I suppose we could add 
>>paravirt ops for __send_IPI_shortcut and every other op that touches the APIC. 
> 
> 
> While that's basically what we did in Xen, it would make more sense to
> build it into genapic which would give us one common abstraction to base
> from.  We should avoid adding pv_ops when existing infrastructure exists.

I agree with this.

Chris, would you like to work together on this?  I don't know what Xen's 
requirements are for the APIC interface.  Do you think we could come up with 
something that would fit both of our needs, and maybe also be usable for some of 
the subarch-specific code?

Dan.
