Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYCDLrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYCDLrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYCDLqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:46:52 -0500
Received: from ns2.suse.de ([195.135.220.15]:38315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbYCDLqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:46:52 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: early_res and find_e820_area for i386?
Date: Tue, 4 Mar 2008 12:46:47 +0100
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <1204601883.4707.96.camel@caritas-dev.intel.com> <200803041141.28404.ak@suse.de> <20080304104853.GA19022@elte.hu>
In-Reply-To: <20080304104853.GA19022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041246.47737.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 11:48:53 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > On Tuesday 04 March 2008 04:38:03 Huang, Ying wrote:
> > 
> > > Is it better to implement early_res and find_e820_area on i386? Can 
> > > we trust E820 table on i386?
> > 
> > The 64bit code is certainly more flexible and cleaner, but also much 
> > more complicated.. [...]
> 
> i disagree, the early_res stuff is still quite unclean, 

I was mostly refering to the main e820 allocator.

early_res is just an addon table for kernel internal use. While you
could put that into the main e820 table too if you made that one variable
sized I don't think it would make too much difference either way. 
It's just a minor tweak of the data structure.

-Andi
