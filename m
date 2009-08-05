Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbZHEMTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbZHEMTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbZHEMTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:19:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933528AbZHEMTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:19:46 -0400
Date: Wed, 5 Aug 2009 15:19:23 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, sheng@linux.intel.com,
       avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86/apic: Enable x2APIC without interrupt
	remapping under KVM
Message-ID: <20090805121923.GI4764@redhat.com>
References: <20090720122417.GR5638@redhat.com> <tip-ee6a28296de295d62a3d8fad8bab58a8a48d006f@git.kernel.org> <20090804133715.GA29573@elte.hu> <20090804165702.GF4764@redhat.com> <20090805121621.GA31918@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805121621.GA31918@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 02:16:21PM +0200, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > +static inline void x2apic_force_phys()
> > +{
> > +}
> 
> Sigh. Have you tested this patche and have you looked at the 
> resultig compiler output?
> 
I haven't looked and compiler output. What is wrong with it?
Is defining this function as #define would be batter?

--
			Gleb.
