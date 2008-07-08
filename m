Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYGHVSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYGHVSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYGHVSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:18:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:26184 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYGHVSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cDl/sIBsPVDJYbuhl7G9Hn2Ja0hHYM0NzGMXED4YL5L+K6WC22BcJIIpwQRVODbUWN
         fUNEuXkxQy/ri/ngSQWGROh4c5r4FmJAQgcmxSW7lPYUouT19QJgpHUed6BC9dNXXL7p
         x5uh3ZliczQ7Y0xKu08JSyGdPcRMcl719+Dq8=
Message-ID: <bc64b4640807081418ia871a24me96458bcf64ca9a0@mail.gmail.com>
Date: Wed, 9 Jul 2008 01:18:44 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Generic per-device coherent dma allocator
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080630105835.GA27466@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080629101846.GA23362@doriath.ww600.siemens.net>
	 <20080630105835.GA27466@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/30 Ingo Molnar <mingo@elte.hu>:
>
> * Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>> Currently x86_32, sh and cris-v32 provide per-device coherent dma
>> memory allocator. However their implementation is nearly identical.
>> Refactor out common code to be reused by them.
>
> looks good to me in principle.
>
> Andrew, Jesse: i've put this aside into the core/generic-dma-coherent
> git tree which you can check at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/generic-dma-coherent
>
> there's some interaction with other x86 bits so i guess it would be best
> to carry this in -tip.
>
> Do the generic bits look good to you? (find the shortlog and diff below)
> It's not yet propagated into linux-next, pending your ack/nak and
> pending some test exposure.
>

I still don't see this in the linux-next. Is it simply a metter of
time? Can I expect
these two patches to be merged during 2.6.27 cycle?
-- 
With best wishes
Dmitry
