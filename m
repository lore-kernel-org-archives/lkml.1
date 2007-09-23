Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXIWDS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXIWDS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 23:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXIWDSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 23:18:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbXIWDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 23:18:22 -0400
Date: Sat, 22 Sep 2007 20:11:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Thomas Gleixner <tglx@linutronix.de>, mihai.dontu@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
In-Reply-To: <E1IZG8l-0002jB-2k@flower>
Message-ID: <alpine.LFD.0.999.0709222008580.16478@woody.linux-foundation.org>
References: <20070922220347.586903979@linutronix.de>
 <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
 <E1IZG8l-0002jB-2k@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Sep 2007, Oleg Verych wrote:
>
> As i never had any suspend working ever, let me point this LKML post
> 
> http://mid.gmane.org/200709221746.14429.mihai.dontu@gmail.com
> 
> from Mihal, who just managed to do some other magic in sligtly
> different context (maybe yet another anti "ACPI screwed up").
> 
> Mihai, you can find whole thread by above URL, requesting message-ids
> from in-reply-to or references headers of this message.

>From a "future behaviour" standpoint it would probably be interesting to 
hear whether Mihai can make his machine with not with the old IDE layer 
(which distributions are migrating away from) but with the ATA layer 
(libata) instead. It too should hopefully know about using ACPI to restore 
any ATA controller quirks.

		Linus
