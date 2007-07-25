Return-Path: <linux-kernel-owner+w=401wt.eu-S1764828AbXGYH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764828AbXGYH3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYH3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:29:06 -0400
Received: from rex.snapgear.com ([203.143.235.140]:38755 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752287AbXGYH3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:29:04 -0400
Message-ID: <46A6FBBA.7080702@snapgear.com>
Date: Wed, 25 Jul 2007 17:28:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Lindsay Roberts <lindsay.roberts.os@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [Celinux-dev] Re: [PATCH] fs: Add romfs version 2
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>		<20070717013635.d6d0b124.akpm@linux-foundation.org>		<20070717192100.GE11166@waste.org>	<8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com> <469E4791.5040806@am.sony.com>
In-Reply-To: <469E4791.5040806@am.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Tim Bird wrote:
> Lindsay Roberts wrote:
>> Yes, my experience has been that it has been almost chillingly close
>> to .5k per regular file increase in partition size. I know in
>> applications in which size is utterly critical this may be slightly
>> unattractive, but in cases where romfs is chosen for its byte
>> reproducibility and read-only nature the size/performance tradeoff is
>> fairly advantageous.
> 
> The size increase makes this a complete non-starter in the
> embedded configs I'm familiar with.  Size is still the number
> one problem using Linux in consumer electronics products.
> 
> I have nothing against this patch, if it achieve some speedups
> for other environments.  But I wouldn't expect to see this
> option used much in embedded devices.

Romfs is used quite extensively in the uClinux space, and
mostly on very small flash setups (can be as small as 1MB
of flash). Any filesystem size increase would not be
welcomed :-)

But ofcourse as long as the romfs filesystem code still
supports the older version there is no problem (and it
looks like it does).

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
