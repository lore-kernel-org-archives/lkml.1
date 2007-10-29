Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXJ2Wpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXJ2Wpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXJ2WpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:45:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14606 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbXJ2WpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:45:17 -0400
Message-ID: <47266275.70403@ct.jp.nec.com>
Date: Mon, 29 Oct 2007 15:45:09 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 1/3] x86: add lapic_shutdown for x86_64
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com>	<20071024062933.GA4622@in.ibm.com> <471FB8D2.5060208@ct.jp.nec.com> <m1odeo6ns0.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odeo6ns0.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:
> 
>>> Do we really have to introduce this function for 64bit? I remember some
>>> issues were faced on i386 w.r.t kernel enabling the LAPIC against the
>>> wishes of BIOS hence kernel was disabling it while shutting down. No
>>> such problems were reported for x86_64 hence this function existed only
>>> for i386.
>> Thanks for the comment. I didn't know the issues, so I'd simply added
>> this function for unification.
>>
>>> If that is the case, probably we don't have to introduce lapic_shutdown()
>>> for x86_64. Instead call lapic_shutdown() for X86_32, and disble_local_APIC()
>>> otherwise?
>> I will do that. I was thinking which is good when posting these patches.
> 
> I'm a little concerned here.  This sounds like forced unification.
> If we can't clean up the infrastructure so things are obviously better
> and cleanly factored for both architectures we should not unify the files.
> 
> As a general principle I would rather have two crudy files side by
> side the one super crudy file.
> 
> So for unification I suggest finally fixing this right and taking the
> apics completely out of the kexec on panic path.

Thanks for the suggestion.
But it's hard for me to imagine.
I'll try to consider about it.

Thanks
Hiroshi Shimamoto
