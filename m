Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbYHGWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbYHGWnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYHGWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:42:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYHGWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:42:57 -0400
Date: Thu, 7 Aug 2008 15:42:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [Linux 2.6.27-rc2] suspend to disk, libata problem
In-Reply-To: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808071541150.3462@nehalem.linux-foundation.org>
References: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Maciej Rutecki wrote:
>
> I have problem with suspend to disk. On 2.6.26.* works fine.
> 
> During s2disk i have this messages (with "no_console_suspend" kernel option):
> http://unixy.pl/maciek/download/kernel/2.6.27-rc2/img_0005.jpg
> (hibernation fails)
> 
> Config, dmesg (normal booting):
> http://unixy.pl/maciek/download/kernel/2.6.27-rc2/

Any chance to get this bisected? I realize that it's quite a few reboots, 
and _maybe_ Jeff or Bartlomiej can just say "oh, duh, it's because of 
Xyz", but the more likely thing is that without a bisect people will be 
flailing around fairly blindly..

			Linus
