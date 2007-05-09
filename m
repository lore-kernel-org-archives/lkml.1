Return-Path: <linux-kernel-owner+w=401wt.eu-S935474AbXEICXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474AbXEICXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967626AbXEICXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:23:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967548AbXEICXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:23:34 -0400
Message-ID: <46413087.2020505@zytor.com>
Date: Tue, 08 May 2007 19:23:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: yhlu <yhlu.kernel@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       vgoyal@in.ibm.com, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org>	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>	<m1sla7i68s.fsf@ebiederm.dsl.xmission.com>	<86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>	<86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>	<m1k5vji107.fsf@ebiederm.dsl.xmission.com>	<86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>	<4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>	<86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>	<46410403.4050802@zytor.com> <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I expect I can find a few more examples where we specify
> video_cols and video_lines but we use video_mode == 0.
> 
> Going farther mode 0x00 is a BIOS 40x25 mode.  So the patch below is
> not always safe even if we boot the bzImage.  It is just highly
> unlikely anyone would start the kernel in 40x25 text mode. 
> 

Mode 0x00 is, at least theoretically, BIOS 40x25 *grayscale*; this mode
(and mode 0x02 which is the same thing in 80x25) were as far as I know
only ever used with composite monitors off CGA cards, i.e. functionally
never.  Actual monochrome monitors used mode 0x07.

	-hpa
