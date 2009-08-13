Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZHMXYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZHMXYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZHMXYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:24:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:32268 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZHMXYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sdQF0QA1roAL72YL3p6GwrpMJsfK8oA7T9SHnpliSR3lzVJAZjRpo0NRKB+Ssfco2P
         /5kIZ08f+b1kHy/Nc7MeLOTXeogtjijzEjofmFdZ4VW1ZwWX5eW7ZpcOYHUbxTk5F1u5
         Re2lXOx39u1qlCPgUniZp8IZT2Hq0+uc2Bw2s=
Message-ID: <4A84A0BA.7040802@gmail.com>
Date: Thu, 13 Aug 2009 20:24:42 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
References: <4A7E0797.7060504@gmail.com> <20090810131219.GD21879@aftab> <4A80A5AD.2000209@gmail.com> <19073.33348.459260.456740@pilspetsen.it.uu.se> <20090811155106.GB16173@aftab> <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com> <20090811160116.GD16173@aftab> <4A8209B6.8050306@gmail.com> <20090812114038.GD15396@aftab> <4A8349F6.9080107@gmail.com> <20090813122337.GB7029@aftab>
In-Reply-To: <20090813122337.GB7029@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi Kevin,
> 
> On Wed, Aug 12, 2009 at 08:02:14PM -0300, Kevin Winchester wrote:
>> So that feature is definitely set.
> 
> thanks for testing. As a reply to that follow two patches for you to
> test. The one is adding some more msr functionality and the second is
> based on your original one which should in addition turn off the cpuid
> bit. Please apply, compile, reboot and run the small app again to verify
> that ECX[0] is now off.
> 
> Let me know how it goes.
> 

Yes, those patches seem to fix everything:

$ ./a.out  
0x8000_0001_ecx = 0x00000000

I just noticed that my original patch has been pulled into Linus' tree,
so you will likely want to rebase your patches on top of that.

Thank you again,

-- 
Kevin Winchester

