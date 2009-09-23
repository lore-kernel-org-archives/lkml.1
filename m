Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZIWTEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZIWTEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZIWTEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:04:07 -0400
Received: from claw.goop.org ([74.207.240.146]:46560 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZIWTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:04:07 -0400
Message-ID: <4ABA7119.6000307@goop.org>
Date: Wed, 23 Sep 2009 12:03:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: Check NX state before setting up GDT mapping
References: <4AB7EC1D.5010102@goop.org> <20090923123616.GC19385@elte.hu>
In-Reply-To: <20090923123616.GC19385@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/09 05:36, Ingo Molnar wrote:
>> +#ifdef CONFIG_X86_64
>> +	/* Work out if we support NX */
>> +	check_efer();
>> +#endif
>> +
>>     
> btw., this #ifdef could sure be eliminated, right?
>   

check_efer() is only defined on x86-64 and all its existing callsites
have a similar #ifdef.  NX setup is an area which could do with a bit of
hitting with the unification stick.

    J
