Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXCFJPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXCFJPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXCFJPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:15:08 -0500
Received: from ns.suse.de ([195.135.220.2]:40510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbXCFJPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:15:06 -0500
Message-ID: <45ED3121.8090308@suse.de>
Date: Tue, 06 Mar 2007 10:15:13 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu>
In-Reply-To: <20070306085222.GA17002@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gerd Hoffmann <kraxel@suse.de> wrote:
> 
>>> [using vmi rom]
>> IIRC there was some proof-of-concept at least for xen guests.
> 
> yes - but de-facto contradicted by the Xen paravirt_ops patches sent to 
> lkml ;)

Yep.  The fact that it is possible to do that doesn't imply that it is
the best solution.

Oh, and btw:  What was the reason why kvm paravirtualization doesn't use
the vmi interface?

>>> the QA matrix is gonna be a _mess_.
>> I fail to see how xen-via-vmirom instead of xen-via-paravirt_ops 
>> reduces the QA effort.  You still have 5 Hypervisors you have to test 
>> against.
> 
> yes, just like we have thousands of separate PC boards to support. But 
> as long as the basic ABI is the same, the QA effort on the Linux kernel 
> side is alot more focused.

xen and vmware are still two very different hypervisors from the memory
mangement point of view.  I doubt moving the abstraction line within the
linux kernel from paravirt_ops to vmi makes QA easier.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
