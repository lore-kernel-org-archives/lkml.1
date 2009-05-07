Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbZEGPcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbZEGPcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbZEGPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:32:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbZEGPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:32:04 -0400
Message-ID: <4A02FE91.8070006@zytor.com>
Date: Thu, 07 May 2009 08:30:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Lameter <cl@linux.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>	<1241560625.8665.17.camel@alok-dev1>	<alpine.DEB.1.10.0905071010170.24528@qirst.com> <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 7 May 2009 10:13:52 -0400 (EDT)
> Christoph Lameter <cl@linux.com> wrote:
> 
>> I think we need to reduce the general tick frequency to be as low as
>> possible. With high resolution timers the tick frequency is just the
>> frequency with which the timer interrupt disturbs a running application.
>>
>> Are there any benefits remaining from frequent timer interrupts? I would
>> think that 60 HZ would be sufficient.
> 
> 50 works for various european video apps, 60 breaks, 60 works for various
> US video apps, 50 breaks. Now that may have changed with all the select
> stuff being hrtimer based (which I'd missed).

Hence 300 Hz.  ;)

> Hooray - finally someone admits the *real* problem here, and for power
> management too. Otherwise known as "referencing jiffies as a variable must
> die"

Amen.  Also, "using HZ as a unit of measurement must die, too."

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

