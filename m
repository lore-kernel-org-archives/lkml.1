Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYL0Azz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYL0Azz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYL0Azq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:55:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYL0Azq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:55:46 -0500
Message-ID: <49557CEA.4030109@zytor.com>
Date: Fri, 26 Dec 2008 16:55:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <alessandro.zummo@towertech.it>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Soekris net5501 board support code
References: <20081226022602.342db591@i1501.lan.towertech.it> <20081226164156.371a8b14.akpm@linux-foundation.org>
In-Reply-To: <20081226164156.371a8b14.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 26 Dec 2008 02:26:02 +0100 Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> 
>>  This patch detects the net5501 board and instantiates the
>>  correct platform devices (GPIO and leds).
>>
>>  Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
>>
>> ---
>>  arch/x86/Kconfig          |    9 +++
>>  arch/x86/kernel/Makefile  |    1 
>>  arch/x86/kernel/soekris.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++
> 
> You might want to tell the x86 maintainers about this :)

The current consensus (to the extent that one exists) seems to be that
platform device drivers belong in drivers[/platform]/x86, instead of in
arch/x86.  drivers/platform doesn't exist in the current -linus tree,
but Len Brown has patches to do it which should be pushed upstream in
this merge window.  In the meantime, use the old name drivers/misc (a
misnomer today, but won't be for much longer.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

