Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZGTTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZGTTvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZGTTvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:51:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47522 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZGTTvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rDc08Ci9AFA5pmIfGFJH0odISOAWHTbzVEJwgxApz3l8xP+0sEpPoszJd2hg06CWgs
         S4iHknEEMTZJA/S1X4vMaHkkd9yMFoTbPfbOt2k5BkyzqaUNurkezcwAlvvqC72+qnnK
         xtLAhwes2HeyIFWYfI2g16O94m6UAjVW8EeRc=
MIME-Version: 1.0
In-Reply-To: <1248098773.15751.8908.camel@twins>
References: <4A647358.1040009@shipmail.org> <1248098773.15751.8908.camel@twins>
Date: Tue, 21 Jul 2009 05:51:14 +1000
Message-ID: <21d7e9970907201251l5ee1cfa6m2bfb783c54687a85@mail.gmail.com>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Dave Airlie <airlied@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Peter Zijlstra <peterz@infradead.org>:
> On Mon, 2009-07-20 at 15:38 +0200, Thomas Hellström wrote:
>> Politics:
>> It's true that sometimes some people don't like the code or what it
>> does. But when this is the underlying cause of NAK-ing a driver I think
>> it's very important that this is clearly stated, instead of inventing
>> various random reasons that can easily be argued against. How should the
>> driver writer otherwise get it right? Man-years might be spent fixing up
>> drivers that will never get upstream anyway.
>>
>> I think it would help a lot of there was a documented set of driver
>> features that were required and sufficient for a DRM driver to go
>> upstream. It could look something like
>>
>>     * Kernel coding style obeyed. Passing checkpatch.
>
>      * fully functional GPL user-space driver.
>
> How can you argue that something as tailor made as a DRM interface can
> be used without it being a derived work?

For a start the userspace is MIT licensed generally, also with architectures
such as gallium3D you can't easily say a driver is derived from the kernel
interface. Actually generally the argument is the drm interface would
be derived work
of the userspace. Kernel hackers aren't lawyers so I cringe whenever one of them
says derived work, without understanding that 80-90% of the code is probably in
the userspace 3D driver, so proving its derived from a 1000 line
kernel interface
is where it gets messy, and hence why a number of lawyers for Intel have already
come down on thinking it was acceptable and from what I can see are still
shipping kernels with an open drm but a closed userspace.

So I'm not saying I agree with having these I'm just saying its not
your 1000 line
regulatory daemon case.

Dave.
