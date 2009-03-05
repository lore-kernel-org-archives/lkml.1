Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZCEOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZCEOcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZCEOcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:32:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:34986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZCEOcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:32:02 -0500
Subject: Re: [git-pull -tip V2] x86: msr architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305141129.GB27962@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain>
	 <20090302205437.GB14471@elte.hu>
	 <1236194183.4994.9.camel@localhost.localdomain>
	 <1236199796.3130.3.camel@localhost.localdomain>
	 <20090305122157.GA7347@alberich.amd.com> <20090305133208.GC4322@elte.hu>
	 <1236260891.4237.1.camel@localhost.localdomain>
	 <20090305141129.GB27962@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 20:01:27 +0530
Message-Id: <1236263487.2527.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:11 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Thu, 2009-03-05 at 14:32 +0100, Ingo Molnar wrote:
> > > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > >  
> > > > - I've just one directory in debugfs
> > > >   x86/cpu/msr/cpu0
> > > >   The system has a quad-core CPU. So I guess there should be 4
> > > >   directories -- one for each core.
> > > 
> > > Correct, most MSRs are per core - that needs to be fixed.
> > 
> > Ok I will support all cores in next Version.
> 
> the VFS structure should be something like:
> 
>  /debug/x86/cpu/cpu0/msr/...
> 
> I.e. first we have the CPU, then a specific CPU, and MSRs are 
> attributes of that CPU (core).
> 

I am also planning to add other CPU registers beside MSRs so msr will
differentiate that it is MSRs or normal register.

And we can move architecture independent code in kernel/* so that
another architectures will also take benefit from it.

--
JSR

