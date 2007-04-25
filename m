Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXDYNMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXDYNMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992737AbXDYNMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:12:10 -0400
Received: from mail.suse.de ([195.135.220.2]:33106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992735AbXDYNMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:12:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Fernando Luis =?iso-8859-15?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 2/10] safe_apic_wait_icr_idle - x86_64
Date: Wed, 25 Apr 2007 15:11:59 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp> <200704251426.14398.ak@suse.de> <1177505712.19745.18.camel@sebastian.intellilink.co.jp>
In-Reply-To: <1177505712.19745.18.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200704251511.59495.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 14:55:12 Fernando Luis Vázquez Cao wrote:
> On Wed, 2007-04-25 at 14:26 +0200, Andi Kleen wrote:
> > >  static __inline__ void apic_wait_icr_idle(void)
> > >  {
> > > -	while (apic_read( APIC_ICR ) & APIC_ICR_BUSY)
> > > +	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
> > >  		cpu_relax();
> > >  }
> > >  
> > > +static __inline__ unsigned int safe_apic_wait_icr_idle(void)
> > 
> > This should be probably not inline -- too large
> Hello Andi,
> 
> Thank you for reviewing the patches. Do you want me to resend the whole
> patch or should I cook a new one that un-inlines the function instead?

I already did that.

Also will apply Keith's suggestion.

-Andi



