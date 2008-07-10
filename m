Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYGJHFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYGJHFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbYGJHFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:05:03 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20789 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYGJHFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:05:01 -0400
Message-ID: <4875B497.7060309@msgid.tls.msk.ru>
Date: Thu, 10 Jul 2008 11:04:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
References: <4873E27C.6050504@msgid.tls.msk.ru> <20080709163618.GA5462@joi>
In-Reply-To: <20080709163618.GA5462@joi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> On Wed, Jul 09, 2008 at 01:56:12AM +0400, Michael Tokarev wrote:

[random complete hangs on 2.6.25 but not 2.6.24]

> Definitely try 2.6.26-rc9 (which will soon become 2.6.26, so people will

Ok, tried 2.6.26-rc9 today night - after disabling some drivers which
were not compilable and fixing some places in core code.  It does the
same thing - i.e. it locks up the same way as 2.6.25 did, and locks up
hard as before (no keyboard and network working).

> probably ask you to test patches on top of this kernel) and if it will still 
> lock up, take a look at Documentation/nmi_watchdog.txt and maybe
> Documentation/networking/netconsole.txt in kernel sources.

Aha!.  That's very useful information, let me try just that... later
today, after work hours.  Added nmi_watchdog=1 and vga=0x5032 (in a
hope to see the whole thing on the screen) to 2.6.26pre lilo line...

Thanks!
