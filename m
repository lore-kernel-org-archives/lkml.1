Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXCFKPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXCFKPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCFKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:15:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:32884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbXCFKPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:15:05 -0500
Message-ID: <45ED3F29.6000705@suse.de>
Date: Tue, 06 Mar 2007 11:15:05 +0100
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
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu>
In-Reply-To: <20070306093436.GA30239@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gerd Hoffmann <kraxel@suse.de> wrote:
> 
>> Oh, and btw: What was the reason why kvm paravirtualization doesn't 
>> use the vmi interface?
> 
> cleanliness and performance: KVM doesnt need any artificial indirection.

Xen doesn't need it either.

> IMO the GPL-ed ROM portion of VMI was a bad idea to begin with.

So why do you want xen use vmi then?

> well, the VMI patches got into Linux with the claim that it's also 
> useful for Xen. So that claim was ... not actually true?

As mentioned there was a proof-of-concept VMI ROM done by vmware.  As
far I know it translated the VMI ROM interface calls into xen hypercalls
somehow, Zach probably has more details.

So in the end you would still have two different hypervisor ABI's, the
VMI ROM just hides that.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
