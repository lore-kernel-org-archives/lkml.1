Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZHMO5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZHMO5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZHMO5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:57:53 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:46432 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZHMO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ELnIOxdHD2G81LngQ5ZQSv1iEhgSvCdZBB79s9AX9DSDWb4gkYXCv6ApQpy3+F44Rk
         hbjQbuLr5x+5dC/dMPz6tyztJra4RfdJpetEzcdlMYCU4P5OKzYrzQzkQvZ6AW/yXtaM
         91m4FOg0tH+l+2nt7+rUFo9NmN8GvpKzZiCf0=
MIME-Version: 1.0
In-Reply-To: <20090813122337.GB7029@aftab>
References: <4A7E0797.7060504@gmail.com> <4A80A5AD.2000209@gmail.com>
	 <19073.33348.459260.456740@pilspetsen.it.uu.se>
	 <20090811155106.GB16173@aftab>
	 <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
	 <20090811160116.GD16173@aftab> <4A8209B6.8050306@gmail.com>
	 <20090812114038.GD15396@aftab> <4A8349F6.9080107@gmail.com>
	 <20090813122337.GB7029@aftab>
Date: Thu, 13 Aug 2009 11:57:51 -0300
Message-ID: <d1af83620908130757l2c5f2383ob9578669bf3d8f0@mail.gmail.com>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
From: Kevin Winchester <kjwinchester@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/13 Borislav Petkov <borislav.petkov@amd.com>:
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

Looking at your patch, I now see why my attempt to read/write the MSRs
failed - magic. :)

I will try these patches this evening when I get back to my computer
and let you know, but they look good to me.

Thanks for all the help,

-- 
Kevin Winchester
