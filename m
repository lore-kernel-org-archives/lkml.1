Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZELQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZELQmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZELQmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:42:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbZELQmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:42:04 -0400
Message-ID: <4A09A688.6080603@zytor.com>
Date: Tue, 12 May 2009 09:40:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam> <20090512141027.GA19143@aftab>
In-Reply-To: <20090512141027.GA19143@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>>
>> why we need cpuid_level ?
> 
> It is already visible in userspace. I think you've got an answer to a
> very similar question already:
> 
> http://marc.info/?l=linux-kernel&m=124206571628464
> 

extended_cpuid_level should be motivated, but probably does make sense.
 It hardly "completes" /proc/cpuinfo; especially if you consider that
there are at least three additional ranges in wide use (two used by a
single vendor only, and the third by virtualization software.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

