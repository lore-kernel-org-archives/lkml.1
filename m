Return-Path: <linux-kernel-owner+w=401wt.eu-S1946388AbXBQDRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946388AbXBQDRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946389AbXBQDRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:17:35 -0500
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:45787 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946388AbXBQDRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:17:34 -0500
From: Con Kolivas <kernel@kolivas.org>
To: "michael chang" <thenewme91@gmail.com>
Subject: Re: [ck] Re: 2.6.20-ck1
Date: Sat, 17 Feb 2007 14:17:28 +1100
User-Agent: KMail/1.9.5
Cc: "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <200702162110.03355.kernel@kolivas.org> <200702171213.40718.kernel@kolivas.org> <b14e81f00702161815x13c25936r49f540beeda3e334@mail.gmail.com>
In-Reply-To: <b14e81f00702161815x13c25936r49f540beeda3e334@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702171417.28376.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 13:15, michael chang wrote:
> On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> > I'm thru with bashing my head against the wall.
>
> I do hope this post isn't in any way redundant, but from what I can
> see, this has never been suggested... (someone please do enlighten me
> if I'm wrong.)
>
> Has anyone tried booting a kernel with the various patches in question
> with a mem=###M boot flag (maybe mem=96M or some other "insanely low
> number" ?) to make the kernel think it has less memory than is
> physically available (and then compare to vanilla with the same
> flags)? It might more clearly demonstrate the effects of Con's patches
> when the kernel thinks (or knows) it has relatively little memory
> (since many critics, from what I can tell, have quite a bit of memory
> on their systems for their workloads).
>
> Just my two cents.

Oh that's not a bad idea of course. I've been testing it like that for ages, 
and there are many -ck users who have testified to swap prefetch helping in 
low memory situations for real as well. Now how do you turn those testimonies 
into convincing arguments? Maintainers are far too busy off testing code for 
16+ cpus, petabytes of disk storage and so on to try it for themselves.  Plus 
they worry incessantly that my patches may harm those precious machines' 
performance... 

-- 
-ck
