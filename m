Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZJFSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZJFSst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbZJFSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:48:48 -0400
Received: from claw.goop.org ([74.207.240.146]:59805 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbZJFSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:48:47 -0400
Message-ID: <4ACB90EA.2070701@goop.org>
Date: Tue, 06 Oct 2009 11:48:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [Xen-devel] [PATCH 5/5] xen/time: add	pvclock_clocksource_vread
 support
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-6-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB37E802000078000182EC@vpn.id2.novell.com>
In-Reply-To: <4ACB37E802000078000182EC@vpn.id2.novell.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 03:28, Jan Beulich wrote:
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1814,6 +1814,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>> # endif
>> #else
>> 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
>> +	case FIX_PVCLOCK_TIME_INFO:
>> #endif
>> #ifdef CONFIG_X86_LOCAL_APIC
>> 	case FIX_APIC_BASE:	/* maps dummy local APIC */
>>     
> And I think this added case also needs to move past the #endif.
>   

No, for the same reason.

    J
