Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZELTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZELTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZELTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:49:46 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54146 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZELTtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KFFQK4E1AVEdmuc54twLybOG2uq1ARCkXLMo6OfcodKYDQ1hualJ33DDovVMO8hMWv
         V0p3TmwQr3wM5B135AoFbwMe5P+CbKoE5xIpVRm/2947GsZbrGSsIMoON+LVqQxbCPRH
         SOfLC44jv8g9+LcxswEkjZeEedCP3VZD4NxP8=
MIME-Version: 1.0
In-Reply-To: <4A09C444.9070809@zytor.com>
References: <1242112482.3283.1.camel@localhost.localdomain>
	 <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam>
	 <20090512141027.GA19143@aftab> <4A09A688.6080603@zytor.com>
	 <20090512181358.GC19143@aftab> <4A09C444.9070809@zytor.com>
Date: Tue, 12 May 2009 21:49:45 +0200
Message-ID: <9ea470500905121249i5fddf318lde5377d3d438854a@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for 
	/proc/cpuinfo
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 8:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Borislav Petkov wrote:
>>
>>>  It hardly "completes" /proc/cpuinfo; especially if you consider that
>>> there are at least three additional ranges in wide use (two used by a
>>> single vendor only, and the third by virtualization software.)
>>
>> I think both vendors use the two ranges :-o).
>>
>
> No, I'm taking about the 0x8086xxxx and 0xC000xxxx used by two other
> vendors (neither of which you and I work for, and at least one of which
> is defunct.)

Ah, yes. Gotcha.

-- 
Regards/Gruss,
Boris
