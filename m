Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbXDJVav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbXDJVav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXDJVau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:30:50 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:53095 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXDJVat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:30:49 -0400
Date: Tue, 10 Apr 2007 23:28:11 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
In-Reply-To: <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr>
References: <20070410181654.GA10525@arun.site> <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 17:25, Robert P. J. Day wrote:
>On Tue, 10 Apr 2007, Jan Engelhardt wrote:
>> On Apr 10 2007 23:46, Milind Arun Choudhary wrote:
>>
>> >"use spin_lock_init instead of SPIN_LOCK_UNLOCKED"
>>
>> Fact is, we cannot remove SPIN_LOCK_UNLOCKED. It's needed for
>> variables outside functions:
>>
>> static spinlock_t foobar = SPIN_LOCK_UNLOCKED;
>
>but that's where you would use the more explicit
>__RAW_SPIN_LOCK_UNLOCKED, no?  AFAIK, you really can remove the macro
>SPIN_LOCK_UNLOCKED in its entirety.

I don't remember LDD speaking about __RAW_*. (And other than not
having looked into the code to date, I don't know the difference.)


Jan
-- 
