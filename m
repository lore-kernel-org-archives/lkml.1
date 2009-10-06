Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZJFK3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZJFK3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZJFK3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:29:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32655 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZJFK3E convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Tue, 6 Oct 2009 06:29:04 -0400
Message-Id: <4ACB37E802000078000182EC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 06 Oct 2009 11:28:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>
Cc: "Keir Fraser" <keir.fraser@eu.citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Dan Magenheimer" <dan.magenheimer@oracle.com>,
       <kurt.hackel@oracle.com>, "Zach Brown" <zach.brown@oracle.com>,
       "Avi Kivity" <avi@redhat.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 5/5] xen/time: add
	 pvclock_clocksource_vread support
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
 <1254790211-15416-6-git-send-email-jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1254790211-15416-6-git-send-email-jeremy.fitzhardinge@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> 06.10.09 02:50 >>>
>--- a/arch/x86/xen/mmu.c
>+++ b/arch/x86/xen/mmu.c
>@@ -1814,6 +1814,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
> # endif
> #else
> 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
>+	case FIX_PVCLOCK_TIME_INFO:
> #endif
> #ifdef CONFIG_X86_LOCAL_APIC
> 	case FIX_APIC_BASE:	/* maps dummy local APIC */

And I think this added case also needs to move past the #endif.

Jan

