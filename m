Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZFCGeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZFCGeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZFCGeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:34:03 -0400
Received: from claw.goop.org ([74.207.240.146]:50668 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265AbZFCGeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:34:01 -0400
Message-ID: <4A261957.3040103@goop.org>
Date: Wed, 03 Jun 2009 16:33:59 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/16] xen: disable PAT
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-7-git-send-email-jeremy@goop.org> <alpine.LFD.2.00.0906021736320.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906021736320.3419@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 12 May 2009, Jeremy Fitzhardinge wrote:
>
>   
>> From: Ian Campbell <ian.campbell@citrix.com>
>>
>> Xen imposes a particular PAT layout on all paravirtual guests which
>> does not match the layout Linux would like to use.
>>
>> Force PAT to be disabled until this is resolved.
>>     
>
> No, this can be done via CPUID, which is paravirtualized already.
>   

Stomp the PAT feature flag?  Yes, that's a better idea.

Thanks,
    J
