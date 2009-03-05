Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZCENNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZCENNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZCENLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:11:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:55570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZCENLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:11:13 -0500
Subject: Re: [git-pull -tip V2] x86: msr architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305122157.GA7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain>
	 <20090302205437.GB14471@elte.hu>
	 <1236194183.4994.9.camel@localhost.localdomain>
	 <1236199796.3130.3.camel@localhost.localdomain>
	 <20090305122157.GA7347@alberich.amd.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 18:40:34 +0530
Message-Id: <1236258634.3720.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

Thanks for your review.

On Thu, 2009-03-05 at 13:21 +0100, Andreas Herrmann wrote:
> On Thu, Mar 05, 2009 at 02:19:56AM +0530, Jaswinder Singh Rajput wrote:
> Hi,
> 
> Why do we need this in-kernel?
> We have already access to MSRs via /dev/cpu/*/msr
> 
> Did you have a look at x86info.  (see
> http://www.codemonkey.org.uk/projects/x86info/)
> Recent versions contain a tool called lsmsr -- which shows you MSRs
> and also decodes some bits, e.g.
> 

Its looks good but I have planning to add much more features in
msr_debug and also Ingo suggested to add more features (please check his
email in this thread)

I am planning to use msr_debug for my development and also want to do
System development by using it.

This is just a beginning. I am just making basic setup I will add
features from this point ;-)



> The tool just lacks some detailed MSR definitions for non-AMD CPUs.
> Feel free to add them ... (and to fix bugs if encountered ;-)
> 

Sure I will also check it.
Can you please forward some links or Manuals of AMD to this email
address so that I can also do some magic with AMD or another Intel based
CPUs.

> Of course I've applied your patch to do a sniff test and found the
> following:
> 
> - I've just one directory in debugfs
>   x86/cpu/msr/cpu0
>   The system has a quad-core CPU. So I guess there should be 4
>   directories -- one for each core.
> 

In this Version I just made for cpu0, in V1 I was doing it for each
cpu_core_id, I mean for each package.

I think, there is no point of showing MSR/cores It will show the same
information. Please correct me If I am wrong.

But if you guys want I can make for each core.

> - The file showing MTRRs is misspelled (mttr instead of mtrr).
> 

Ok, I will fix it in next version.

Thanks,
--
JSR

