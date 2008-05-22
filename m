Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYEVTFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYEVTFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYEVTFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:05:25 -0400
Received: from mail.aknet.ru ([78.158.192.26]:52220 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYEVTFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:05:24 -0400
Message-ID: <4835C3DE.8070209@aknet.ru>
Date: Thu, 22 May 2008 23:05:02 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] provide rtc_cmos platform device
References: <483317B4.7060601@aknet.ru> <20080521153223.e989cb88.akpm@linux-foundation.org>
In-Reply-To: <20080521153223.e989cb88.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David, please CC me the replies.

David Brownell wrote:
> Well, "regression" is the wrong phrase. You've switched
> drivers (from the legacy RTC to the new one), so this is
> not the thing which worked for you before.
I am not sure how could that happen.
I am always just taking an old kernel
config and never change the options
that are not supposed to be changed.
Was the old RTC driver removed by any
chance?

>> This may also help running the
>> PNP-enabled kernel on an older PCs.
> As in, pre-PNP. That's pretty darn old!
But... I think they should still be
supported, unless it is too difficult.

> (1) On an ARM build (with no PNP configured):
OK, but unfortunately I can't help
with that. I won't touch any non-x86
arch code, so I'll simply go for
the #ifdef here, or someone else
should make the patch instead. :)

> You shouldn't define those symbols; the right values are already
> defined in <asm/mc146818rtc.h>. RTC_PORT(0) and RTC_PORT(1) are
> the symbolss to use; RTC_IRQ is already defined. All this stuff
> is used in the <asm-generic/rtc.h> code ...
OK, thanks.
I'll update the patch, in todo for
the week-end.
