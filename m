Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXDYMzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXDYMzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXDYMzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:55:15 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47303 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030672AbXDYMzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:55:14 -0400
Subject: Re: [PATCH 2/10] safe_apic_wait_icr_idle - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <200704251426.14398.ak@suse.de>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
	 <1177499715.17974.12.camel@sebastian.intellilink.co.jp>
	 <200704251426.14398.ak@suse.de>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 21:55:12 +0900
Message-Id: <1177505712.19745.18.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 14:26 +0200, Andi Kleen wrote:
> >  static __inline__ void apic_wait_icr_idle(void)
> >  {
> > -	while (apic_read( APIC_ICR ) & APIC_ICR_BUSY)
> > +	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
> >  		cpu_relax();
> >  }
> >  
> > +static __inline__ unsigned int safe_apic_wait_icr_idle(void)
> 
> This should be probably not inline -- too large
Hello Andi,

Thank you for reviewing the patches. Do you want me to resend the whole
patch or should I cook a new one that un-inlines the function instead?

