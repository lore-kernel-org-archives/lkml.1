Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZELSsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZELSsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZELSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:48:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZELSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:48:45 -0400
Message-ID: <4A09C444.9070809@zytor.com>
Date: Tue, 12 May 2009 11:47:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam> <20090512141027.GA19143@aftab> <4A09A688.6080603@zytor.com> <20090512181358.GC19143@aftab>
In-Reply-To: <20090512181358.GC19143@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
>>  It hardly "completes" /proc/cpuinfo; especially if you consider that
>> there are at least three additional ranges in wide use (two used by a
>> single vendor only, and the third by virtualization software.)
> 
> I think both vendors use the two ranges :-o).
> 

No, I'm taking about the 0x8086xxxx and 0xC000xxxx used by two other
vendors (neither of which you and I work for, and at least one of which
is defunct.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

