Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXEHWIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXEHWIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXEHWIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:08:00 -0400
Received: from gw.goop.org ([64.81.55.164]:44565 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbXEHWH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:07:58 -0400
Message-ID: <4640F4B3.30408@goop.org>
Date: Tue, 08 May 2007 15:07:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: yhlu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       "H. Peter Anvin" <hpa@zytor.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org> <46390523.5010809@goop.org>	 <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com> <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
In-Reply-To: <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu wrote:
> On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> You might try a git-bisect, or if it is just these patches
>> walking through them one-by-one.
>
> f82af20e1a028e16b9bb11da081fa1148d40fa6a is first bad commit
> commit f82af20e1a028e16b9bb11da081fa1148d40fa6a
> Author: Gerd Hoffmann <kraxel@suse.de>
> Date:   Wed May 2 19:27:19 2007 +0200
>
>    [PATCH] x86-64: ignore vgacon if hardware not present
>
>    Avoid trying to set up vgacon if there's no vga hardware present.
>
>    Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>    Signed-off-by: Andi Kleen <ak@suse.de>
>    Cc: Alan <alan@lxorguk.ukuu.org.uk>
>    Acked-by: Ingo Molnar <mingo@elte.hu>

Interesting.  I haven't really been following this thread, but doesn't
it mean something isn't being initialized properly if this patch makes a
difference?

    J
