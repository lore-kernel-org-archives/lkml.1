Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZFETTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZFETTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZFETTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:19:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZFETTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:19:00 -0400
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A09A688.6080603@zytor.com>
References: <1242112482.3283.1.camel@localhost.localdomain>
	 <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam>
	 <20090512141027.GA19143@aftab>  <4A09A688.6080603@zytor.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 00:50:06 +0530
Message-Id: <1244229606.2507.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 09:40 -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> >>>
> >> why we need cpuid_level ?
> > 
> > It is already visible in userspace. I think you've got an answer to a
> > very similar question already:
> > 
> > http://marc.info/?l=linux-kernel&m=124206571628464
> > 
> 
> extended_cpuid_level should be motivated, but probably does make sense.
>  It hardly "completes" /proc/cpuinfo; especially if you consider that
> there are at least three additional ranges in wide use (two used by a
> single vendor only, and the third by virtualization software.)
> 

So how can we complete it.

--
JSR

