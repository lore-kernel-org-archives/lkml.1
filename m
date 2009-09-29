Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZI2Rgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZI2Rgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZI2Rgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:36:51 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:45991 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZI2Rgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:36:51 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4AC24396.4080402@zytor.com>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
	 <1253419185.3253.21.camel@ank32.eng.vmware.com>
	 <20090920074247.GA5733@elte.hu>
	 <1253647845.10565.20.camel@ank32.eng.vmware.com>
	 <4AB9CE66.1030504@redhat.com>
	 <1254185107.13456.32.camel@ank32.eng.vmware.com>
	 <4AC17018.4040600@zytor.com>
	 <1254193238.13456.48.camel@ank32.eng.vmware.com>
	 <20090929090130.GD3958@sequoia.sous-sol.org>
	 <1254245124.7803.34.camel@ank32.eng.vmware.com>
	 <4AC24396.4080402@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 29 Sep 2009 10:36:54 -0700
Message-Id: <1254245814.7803.37.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-09-29 at 10:27 -0700, H. Peter Anvin wrote:
> On 09/29/2009 10:25 AM, Alok Kataria wrote:
> > diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
> > index 31e6f6c..d430e4c 100644
> > --- a/arch/x86/kernel/vmi_32.c
> > +++ b/arch/x86/kernel/vmi_32.c
> > @@ -648,7 +648,7 @@ static inline int __init activate_vmi(void)
> >  
> >  	pv_info.paravirt_enabled = 1;
> >  	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
> > -	pv_info.name = "vmi";
> > +	pv_info.name = "vmi [deprecated]";
> >  
> >  	pv_init_ops.patch = vmi_patch;
> >  
> > 
> > 
> 
> Where is this string used, and could this break something?

It is used by default_banner in "arch/x86/kernel/paravirt.c", IMO this
just prints some info for users, shouldn't break anything. 

Alok
> 
> 	-hpa
> 

