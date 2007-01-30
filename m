Return-Path: <linux-kernel-owner+w=401wt.eu-S965557AbXA3Osw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557AbXA3Osw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965563AbXA3Osw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:48:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:6723 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965552AbXA3Osu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dyptEuX7veLiBAlPeeQ0vPP63Kw9NsVhj0JpC2pI4gzNCchY989B5meog3L6ycErEXgtWBiZXBaX3rVLN2l23hWcneqW/vjV0B/g3/MUeFfHvQB4bVDY0U7cUy0xsZ4U0LKk0kUeHFcwXcL6E7WOJIqUALcaPSCDANBZj8X8p1I=
Message-ID: <5157576d0701300648s73b6c083ue8d6af13a0f7a32a@mail.gmail.com>
Date: Tue, 30 Jan 2007 17:48:48 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [BUG] 2.6.20-rc3-mm1: can not mount root
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070130082244.GA5942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com>
	 <20070130001209.b716c14a.akpm@osdl.org>
	 <20070130082244.GA5942@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@osdl.org> wrote:
>
> > Tomasz, is this still happening in 2.6.20-rc6-mm3?
> >
> > err.  We merged that patch.  So perhaps 2.6.20-rc6 now crashes in the
> > same manner?
>
> no, we havent merged that patch yet, but it's:
>
>   x86_64-mm-improve-sched_clock-on-i686.patch
>
> I bet this is due to Qemu simulating a CPU that does not truly exist.

I use qemu+kqemu, so as I understand almost all code executes on my real CPU.

> i suspect it's .config dependent. Tomasz,
>could you send me the .config you used?

I supposed you was agree that
this cause a problem:
> -int tsc_disable __cpuinitdata = 0;
                               ^^^^^^^^^^^^^^^^
