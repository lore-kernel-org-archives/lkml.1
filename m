Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYCYBiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYCYBiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 21:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYCYBiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 21:38:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753553AbYCYBiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:38:04 -0400
Date: Mon, 24 Mar 2008 20:37:59 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] x86_64: Change GET_APIC_ID() from an inline function to an out-of-line function
Message-ID: <20080325013759.GA16549@sgi.com>
References: <20080324182107.GA27979@sgi.com> <86802c440803241534p5c28193brf769280fe05d286d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803241534p5c28193brf769280fe05d286d@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  Index: linux/include/asm-x86/apicdef.h
> >  ===================================================================
> >  --- linux.orig/include/asm-x86/apicdef.h        2008-03-18 14:54:19.000000000 -0500
> >  +++ linux/include/asm-x86/apicdef.h     2008-03-21 09:07:23.000000000 -0500
> >  @@ -14,7 +14,6 @@
> >
> >   #ifdef CONFIG_X86_64
> >   # define       APIC_ID_MASK            (0xFFu<<24)
> >  -# define       GET_APIC_ID(x)          (((x)>>24)&0xFFu)
> >   # define       SET_APIC_ID(x)          (((x)<<24))
> >   #endif
> 
> it this patch after smpboot.c integration?
> 
> that patchsets have GET_APIC_ID in mach_apicdef.h instead of apicdef.h
> 

Sorry - I meant to add to the patches that they are based on linux-2.6.25-rc5-mm1.
Was the change to smpboot.c made in -rc6??

--- jack

