Return-Path: <linux-kernel-owner+w=401wt.eu-S1161787AbXEATIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161787AbXEATIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161789AbXEATIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:08:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:16593 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161787AbXEATIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mCXvUFx8TAFMrqtwbkAVrLKp9A9C+U3lx4XJNERBQT18rgH/NxHLF0YHA6mT6/olDnvfn6Bpg05Sw535PgJtgKr4Ar2Gnx8yxxPB5V46BET0FKkAFPPkQug6/iufzuXh3T6ItjmB7wK95RZZGjD36doGS0utjYW1m9YdPU6KEDk=
Message-ID: <46379027.7050202@gmail.com>
Date: Tue, 01 May 2007 23:08:23 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: ian <spyro@f2s.com>
CC: Paul Sokolovsky <pmiscml@gmail.com>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
References: <1354376306.20070501080806@gmail.com>	 <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com>	 <46376AD9.3020701@gmail.com> <1178042924.15769.5.camel@wirenth>
In-Reply-To: <1178042924.15769.5.camel@wirenth>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ian wrote:
> On Tue, 2007-05-01 at 20:29 +0400, Dmitry Krivoschekov wrote:
>> If you used ASIC acronym it would be more appropriate and not so
>> ambiguous. 
>
> Actually, thats not bad. I'd be ok with that is SoC isnt used.
>
I'm ok with that too, i.e. very rough definition is:
SoC (system-on-chip) is  a platform level chip which incorporates processor
devices (CPU, cache, coprocessors, memory controller etc.), system devices
(timers, interrupt controllers etc.) and peripheral devices
(UARTs, LCD controllers, USB controllers etc),
while ASIC (Application-specific integrated circuit) is also a platform
level
chip which incorporates peripheral and system devices but does not include
processor devices.  ASICs are designed to expand processor functionality,
it could supplement a normal processor (non-SoC) and also could supplement
a SoC processor.


ASIC-related code (I mean core) forms additional platform layer, so I
suggest
adding ASIC helpers to generic platform code i.e. drivers/platform.c, but
ASIC drivers to drivers/asic/ directory.



Regards,
Dmitry
