Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYEDAlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYEDAlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 20:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYEDAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 20:41:30 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59606 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYEDAl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 20:41:29 -0400
Message-Id: <481D0629.8080204@ct.jp.nec.com>
Date: Sat, 03 May 2008 17:41:13 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: move do_nmi() to nmi_32.c
References: <481BA78F.50202@ct.jp.nec.com> <alpine.LFD.1.10.0805032310110.6003@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805032310110.6003@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2 May 2008, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> on x86_64 do_nmi() is in nmi_64.c.
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
> 
> Applied. Are you targeting to merge the 32/64 nmi code eventually ?
> 

Yeah, there are duplicated codes in nmi_*.c.

thanks,
Hiroshi Shimamoto

