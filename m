Return-Path: <linux-kernel-owner+w=401wt.eu-S2992765AbXDYNcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992765AbXDYNcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161728AbXDYNcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:32:48 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:47330 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161742AbXDYNcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:32:47 -0400
Subject: Re: [PATCH 2/10] safe_apic_wait_icr_idle - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andi Kleen <ak@suse.de>
Cc: vgoyal@in.ibm.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       horms@verge.net.au, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <200704251511.59495.ak@suse.de>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
	 <200704251426.14398.ak@suse.de>
	 <1177505712.19745.18.camel@sebastian.intellilink.co.jp>
	 <200704251511.59495.ak@suse.de>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 22:32:46 +0900
Message-Id: <1177507966.19745.24.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 15:11 +0200, Andi Kleen wrote:
> On Wednesday 25 April 2007 14:55:12 Fernando Luis Vázquez Cao wrote:
> > On Wed, 2007-04-25 at 14:26 +0200, Andi Kleen wrote:
> > > >  static __inline__ void apic_wait_icr_idle(void)
> > > >  {
> > > > -	while (apic_read( APIC_ICR ) & APIC_ICR_BUSY)
> > > > +	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
> > > >  		cpu_relax();
> > > >  }
> > > >  
> > > > +static __inline__ unsigned int safe_apic_wait_icr_idle(void)
> > > 
> > > This should be probably not inline -- too large
> > Hello Andi,
> > 
> > Thank you for reviewing the patches. Do you want me to resend the whole
> > patch or should I cook a new one that un-inlines the function instead?
> 
> I already did that.
> 
> Also will apply Keith's suggestion.
Thank you Andi. Sorry for the trouble.

