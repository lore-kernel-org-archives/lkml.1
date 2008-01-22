Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYAVUGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYAVUGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbYAVUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:06:27 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:14264 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYAVUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:06:26 -0500
X-SBRS: None
X-MesageID: 38803512
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,235,1199682000"; 
   d="scan'208";a="38803512"
Message-ID: <47964C7A.6000609@citrix.com>
Date: Tue, 22 Jan 2008 12:05:14 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, hpa@zytor.com,
       akpm@linux-foundation.org, tglx@linutronix.de, roland@redhat.com,
       ak@suse.de
Subject: Re: [PATCH 0/4] paravirt_ops-64 compile fixes
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>	<20080122120207.GA30271@elte.hu>	<20080122123450.GU7338@blackpad> <47962E1D.2090308@goop.org> <20080122194710.GC3218@elte.hu>
In-Reply-To: <20080122194710.GC3218@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> Maybe should this force-paravirt mode be a kernel debugging option?
>>>       
>> No, just a plain CONFIG_PARAVIRT to turn it on and off independently 
>> of everything else.
>>     
>
> it should be a debugging option in the way that it's dependent on 
> KERNEL_DEBUG and KERNEL_EXPERIMENTAL.
>   

EXPERIMENTAL certainly, but not DEBUG.  Sure, CONFIG_PARAVIRT is 
somewhat useless if you don't also configure Xen/lguest/etc, but running 
a paravirt system on bare hardware will probably be the most common way 
a paravirt kernel gets run (a distro will always enable it and compile 
in whatever hypervisor support they want, but most people will end up 
just running it on bare hardware).  Therefore, we should try to be as 
sure as possible that PARAVIRT works well (ie, indistinguishable from 
non-PARAVIRT) on bare hardware.

> i dont think you shold worry about this - i think 64-bit guest support 
> for specific hypervisors could be added even after the merge window, if 
> it's reasonably isolated (which i'd expect it to be). It clearly cannot 
> break anything else so it's the same category as new driver or new 
> hardware support - more relaxed integration rules. Then we can remove 
> the KERNEL_DEBUG and KERNEL_EXPERIMENTAL dependency as well.

Good, I'm glad you feel that way.

    J
