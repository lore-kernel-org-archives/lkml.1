Return-Path: <linux-kernel-owner+w=401wt.eu-S1161201AbXCGCQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161201AbXCGCQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161217AbXCGCQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:16:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53831 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161201AbXCGCQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:16:26 -0500
Message-ID: <45EE2079.1060200@vmware.com>
Date: Tue, 06 Mar 2007 18:16:25 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de>	<20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de>	<20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de>	<20070306102658.GA7478@elte.hu> <45ED4AD8.6020504@suse.de>	<20070306115937.GA25313@elte.hu> <45ED9678.5050907@goop.org> <20070306171130.GA13403@elte.hu>
In-Reply-To: <20070306171130.GA13403@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> We do not let OpenOffice or Evolution have its own separate ABI to Linux 
> so that they 'can evolve at their own pace'... We want them to cooperate 
> and come up with a common ABI (or rather, we try to come up with the 
> right syscalls ourselves), because divering, overlapping ABIs are a huge 
> PITA.
>   

OpenOffice or Evolution are the completely wrong example.  They disprove 
your point more than they prove it.  Consider any significantly large 
cross-platform software like OpenOffice, Evolution, Firefox.  You don't 
let or restrict what these pieces of software do at all.  They evolve at 
their own pace, and they all build their very complicated and divergent 
cross platform compatibility layers, with huge, overlapping APIs, 
converging in places, diverging in others.

> We do not unify their pointlessly diverging ABIs to within the kernel 
> via say office_ops (while we could) because that's crappy on its face. 
> Hypervisors arent in any way different, they just _think_ they are 
> special because they are relatively new. But hey, i dont expect you to 
> concede this point ;)

No, you don't.  The developers of Office and Evolution and Firefox do 
that for you.  And it's not crappy on its face because it provides real 
value to them - the ability to run heterogeneously in multiple different 
environments and across many different platforms and operating systems.

Where your analogy is wrong is that in this case, Linux is very much 
like one of those large software systems.  It has complicated features 
that require special plugins to work efficiently in different hypervisor 
environments.  And paravirt-ops is providing that functionality to 
Linux, just as the platform layer of any large software system does and 
very much should do.

Zach
