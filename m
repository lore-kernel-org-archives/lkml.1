Return-Path: <linux-kernel-owner+w=401wt.eu-S969071AbXEIFIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969071AbXEIFIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXEIFIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:08:46 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXEIFIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:08:45 -0400
Message-ID: <4641573C.1000205@zytor.com>
Date: Tue, 08 May 2007 22:08:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: yhlu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, vgoyal@in.ibm.com,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org>	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>	 <46410403.4050802@zytor.com>	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>	 <46413087.2020505@zytor.com>	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com> <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com> <46415640.6000600@zytor.com>
In-Reply-To: <46415640.6000600@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> yhlu wrote:
>> On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Since the whole point is to detect the case where we don't have
>>> a screen at all it makes sense to check several additional variables
>>> and make certain that they are all 0.  Agreed?
>> need one good way to find if there is support vga console.
> 
> There really isn't one, at least not given the current data structure;
> the data structure has an "isVGA" flag, but if that is 0 it's supposed
> to mean CGA/MDA/HGC/EGA, as opposed to VGA...

Of course, one could argue that since all of those were obsolete by the
time Linux was first created, that it probably doesn't matter and that
isVGA == 0 pretty much means the more obvious thing.

MDA/HGC stuck around for quite a while for debugging, since it was
non-conflicting with VGA, but even if it is, the reason people put it in
their system is to have something that the OS doesn't readily see.

	-hpa
