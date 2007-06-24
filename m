Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXFXAEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXFXAEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXFXAEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:04:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbXFXAEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:04:43 -0400
Message-ID: <20070624020405.78bjajayowkw000k@imap.suse.de>
X-Priority: 3 (Normal)
Date: Sun, 24 Jun 2007 02:04:05 +0200
From: Andreas Kleen <ak@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 26/28] x86-64 block irq balancing for timer
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	<20070623124031.301753868@inhelltoy.tec.linutronix.de>
	<1182634040.2910.7.camel@laptopd505.fenrus.org>
In-Reply-To: <1182634040.2910.7.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat 23 Jun 2007 11:27:20 PM CEST schrieb Arjan van de Ven  
<arjan@infradead.org>:

> On Sat, 2007-06-23 at 13:32 +0000, Thomas Gleixner wrote:
>> plain text document attachment
>> (x86-64-clockevents-irq-balancing.patch)
>> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>>
>> Disable irq balancing on IRQ0.
>
>
> this patch is missing some rationale....

Several SIS chipsets lock up when you try to change affinity of IRQ #0

-Andi

