Return-Path: <linux-kernel-owner+w=401wt.eu-S1763876AbZEHTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763876AbZEHTCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZEHTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:02:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:36110 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZEHTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:02:11 -0400
Message-ID: <4A0481AC.7070409@codemonkey.ws>
Date: Fri, 08 May 2009 14:02:04 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A043E89.90403@novell.com> <4A044786.2080508@codemonkey.ws> <4A047EDE.2020806@redhat.com>
In-Reply-To: <4A047EDE.2020806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>>
>> And we're now getting close to the point where the difference is 
>> virtually meaningless.
>>
>> At .14us, in order to see 1% CPU overhead added from PIO vs HC, you 
>> need 71429 exits.
>>
>
> If I read things correctly, you want the difference between PIO and 
> PIOoHC, which is 210ns.  But your point stands, 50,000 exits/sec will 
> add 1% cpu overhead.

Right, the basic math still stands.

>>
>> The non-x86 architecture argument isn't valid because other 
>> architectures either 1) don't use PCI at all (s390) and are already 
>> using hypercalls 2) use PCI, but do not have a dedicated hypercall 
>> instruction (PPC emb) or 3) have PIO (ia64).
>
> ia64 uses mmio to emulate pio, so the cost may be different.  I agree 
> on x86 it's almost negligible.

Yes, I misunderstood that they actually emulated it like that.  However, 
ia64 has no paravirtualization support today so surely, we aren't going 
to be justifying this via ia64, right?

Regards,

Anthony Liguori

