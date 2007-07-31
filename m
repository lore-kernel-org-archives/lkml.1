Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXHAAAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXHAAAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbXHAAAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:00:20 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:35123 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbXHAAAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:00:18 -0400
Message-ID: <46AFCCBB.70307@gentoo.org>
Date: Tue, 31 Jul 2007 19:58:51 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org> <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org> <4693CCC6.7050400@zytor.com>
In-Reply-To: <4693CCC6.7050400@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

H. Peter Anvin wrote:
>> So, 2.6.22-rc6-mm1 should work fine with CONFIG_FIRMWARE_EDID=y, or are
>> further patches needed?
>>
> 
> It should, yes.

It didn't work, and the bug still exists in 2.6.23-rc1: the resolution 
is wrong by 6 pixels. The user does have CONFIG_FIRMWARE_EDID enabled.

So far the only known working setups since 2.6.20.11 are:
  1. Zwane's patch reverted
  2. Jan's patch applied (to 2.6.22 or lower, I guess it no longer works 
for 2.6.23)

Here is dmesg output from 2.6.23:
http://bugs.gentoo.org/attachment.cgi?id=126203&action=view

Let me know how we can help diagnose this further.

Thanks,
Daniel
