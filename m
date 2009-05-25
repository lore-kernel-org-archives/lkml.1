Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZEYFWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZEYFWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZEYFWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:22:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZEYFWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:22:35 -0400
Message-ID: <4A1A2ADC.1090004@redhat.com>
Date: Mon, 25 May 2009 08:21:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable before
 using it
References: <1242793775.3260.2.camel@localhost.localdomain>	 <4A193BCE.90307@redhat.com> <1243228626.3157.4.camel@localhost.localdomain>
In-Reply-To: <1243228626.3157.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>> It's a false alarm.  Isn't there a macro to shut up the warning?
>>
>>     
>
> In arch/x86/kvm/paging_tmpl.h sptep is initialize only in :
>
> for_each_shadow_entry(vcpu, addr, iterator) {
>
> If we skip this, then we end up with wild sptep and returning it.
>
> Do you still think it is a false alarm ?
>   

That loop always has at least one iteration.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

