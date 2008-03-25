Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYCYCTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYCYCTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYCYCSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:18:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:5986 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYCYCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WMA4FFhkavY139ylGEtodTVoM9pr7EzxQJnDHh/f0o/15K/3nDjJjG9+16Wnw01Mw7KcRjYGkV6KWlMVkCAgpI1YaDCGe7pLlP12V33+8zE2MZjMIXSok8pA0kRVagmxi33p0G1xeEXUCPAyQ+/B8EDUGYWBKCULg1DIrVliqBo=
Message-ID: <86802c440803241918y4e1589e5h6319806238ecd00b@mail.gmail.com>
Date: Mon, 24 Mar 2008 19:18:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [RFC 1/8] x86_64: Change GET_APIC_ID() from an inline function to an out-of-line function
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080325013759.GA16549@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182107.GA27979@sgi.com>
	 <86802c440803241534p5c28193brf769280fe05d286d@mail.gmail.com>
	 <20080325013759.GA16549@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 6:37 PM, Jack Steiner <steiner@sgi.com> wrote:
> > >  Index: linux/include/asm-x86/apicdef.h
>  > >  ===================================================================
>  > >  --- linux.orig/include/asm-x86/apicdef.h        2008-03-18 14:54:19.000000000 -0500
>  > >  +++ linux/include/asm-x86/apicdef.h     2008-03-21 09:07:23.000000000 -0500
>  > >  @@ -14,7 +14,6 @@
>  > >
>  > >   #ifdef CONFIG_X86_64
>  > >   # define       APIC_ID_MASK            (0xFFu<<24)
>  > >  -# define       GET_APIC_ID(x)          (((x)>>24)&0xFFu)
>  > >   # define       SET_APIC_ID(x)          (((x)<<24))
>  > >   #endif
>  >
>  > it this patch after smpboot.c integration?
>  >
>  > that patchsets have GET_APIC_ID in mach_apicdef.h instead of apicdef.h
>  >
>
>  Sorry - I meant to add to the patches that they are based on linux-2.6.25-rc5-mm1.
>  Was the change to smpboot.c made in -rc6??

x86.git#latest

http://people.redhat.com/mingo/x86.git/README

YH
