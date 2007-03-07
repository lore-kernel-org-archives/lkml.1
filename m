Return-Path: <linux-kernel-owner+w=401wt.eu-S2992630AbXCGVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992630AbXCGVjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992632AbXCGVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:39:18 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55005 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992630AbXCGVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:39:18 -0500
Message-ID: <45EF2FFE.7010705@vmware.com>
Date: Wed, 07 Mar 2007 13:34:54 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	 <1173300032.24738.750.camel@localhost.localdomain>	 <45EF2991.1020204@goop.org> <1173303639.24738.814.camel@localhost.localdomain>
In-Reply-To: <1173303639.24738.814.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 21:39:17.0337 (UTC) FILETIME=[0EBB5C90:01C76101]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 01:40 PM, Thomas Gleixner wrote:
> On Wed, 2007-03-07 at 13:07 -0800, Jeremy Fitzhardinge wrote:
> That would certainly be ideal.  We'll look at the xen, vmi, lguest and
>> kvm paravirtualized time models and see how much they really have in
>> common.  I'm a bit curious about how vmi's time events make their way
>> back into the system.
> 
> By the crude mechanism I'm fighting.
>

Hmm?  They make there way back via interrupts.  How is that crude?
