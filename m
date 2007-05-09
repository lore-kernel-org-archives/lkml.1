Return-Path: <linux-kernel-owner+w=401wt.eu-S968944AbXEIFEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968944AbXEIFEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967750AbXEIFE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:04:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967600AbXEIFE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:04:27 -0400
Message-ID: <46415640.6000600@zytor.com>
Date: Tue, 08 May 2007 22:04:00 -0700
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
References: <4634483E.9030307@goop.org>	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>	 <46410403.4050802@zytor.com>	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>	 <46413087.2020505@zytor.com>	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com> <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
In-Reply-To: <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu wrote:
> On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Since the whole point is to detect the case where we don't have
>> a screen at all it makes sense to check several additional variables
>> and make certain that they are all 0.  Agreed?
> 
> need one good way to find if there is support vga console.

There really isn't one, at least not given the current data structure;
the data structure has an "isVGA" flag, but if that is 0 it's supposed
to mean CGA/MDA/HGC/EGA, as opposed to VGA...

	-hpa
