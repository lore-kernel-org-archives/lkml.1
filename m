Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZGSQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZGSQlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZGSQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZGSQlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:41:10 -0400
Date: Sun, 19 Jul 2009 19:40:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090719164059.GC14176@redhat.com>
References: <20090719114411.GN5638@redhat.com> <20090719162735.GB19434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090719162735.GB19434@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 06:27:35PM +0200, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > +	if (!ret) {
> > +		/* IR is required if there is APIC ID > 255 even when running
> > +		 * under KVM
> > +		*/
> 
> Eeek.
> 
> > +	if (x2apic_preenabled) {
> > +		panic("x2apic enabled by bios. But IR enabling failed."
> > +		      " Check that CONFIG_X86_X2APIC and CONFIG_INTR_REMAP are"
> > +		      " enabled.");
> 
> We dont want to break such messages mid-line, it makes it hard to 
> git-grep for them. Also, the '. But' looks weird.

So what should I do? Make really long line?

--
			Gleb.
