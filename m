Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZELAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZELAmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZELAml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:42:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZELAmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:42:40 -0400
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly
 access miscellaneous MSRs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A086B58.30607@zytor.com>
References: <1242058494.5139.7.camel@ht.satnam>  <4A086B58.30607@zytor.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 06:12:59 +0530
Message-Id: <1242088979.2504.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 11:15 -0700, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > 
> > Jaswinder Singh Rajput (15):
> >       x86: Add cpufeature for Processor Name
> >       x86: Add cpufeatures for Advanced Power Management
> >       x86: Add cpufeature for Microcode update
> >       x86: Add cpufeature for Cache MSRs
> >       x86: Add cpufeature for Hard and Soft Poweron configuration
> >       x86: Add cpufeature for Scaleable bus speed
> >       x86: Add cpufeature for Miscellaneous Features
> >       x86: Add cpufeature for Platform feature
> >       x86: Add cpufeature for Hardware configuration
> >       x86: Add cpufeature for System configuration
> >       x86: Add cpufeature for System management mode (SMM)
> >       x86: Add cpufeature for MM configuration
> >       x86: Add cpufeature for Bus configuration
> >       x86: Add cpufeature for performance frequency APERF/MPERF
> >       x86: Add cpufeature for ancient performance monitoring
> > 
> 
> Overall, I'm rather confused what the point of this is supposed to be. 
> There is value to centralizing CPU knowledge, but some of these flags 
> are only used in one place, and as far as I can see in several of your 
> patches they aren't used *at all*.
> 
> If there is no in-kernel user there is absolutely no point to this.
> 

The basic point of these patchset is to friendly access miscellaneous
MSRs in kernel and userspace.

Some of these patches are using hardware cpufeature and others are
software.

In kernel some of these MSRs are frequently used and doing checking
before accessing these MSR in various places.

So I think it will be right approach to check in one place and set
related cpufeature and in other places we only need to check cpufeature
and then access MSR.

This patchset is only adding cpufeature. I will release accessing
cpufeatures in upcoming series.

--
JSR

