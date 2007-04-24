Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXDXIGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXDXIGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDXIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:06:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:63250 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbXDXIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ujWnKFu7Wfk9guejB21x2lk0eu7cmPVIv5ZzXhDLsAxV4EOofKHAbaWaf5mKLr19Z4mdB4BAmFTeThnD5R4i8rqzMIXKuprQNEomrj5Wwg42kjgmYXaMNkFpBzQJb1ouOrqSipYYgfz4cb1A3lzHrXhGVDI/qdPA6S0gDcS6dDI=
Message-ID: <462DBA5C.3090003@gmail.com>
Date: Tue, 24 Apr 2007 11:05:48 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <86245.21997.qm@web36706.mail.mud.yahoo.com>
In-Reply-To: <86245.21997.qm@web36706.mail.mud.yahoo.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>> If you add support for let's say [tifm_8xx2] in the future, which
>> would have port offsets different that [tifm_7xx1], you would also need a
>> completely new modules for slots (sd, ms, etc).
>>
>
> Does not this constitutes an unbounded speculation?
Only time will tell :)
> And then, what would you propose to do with
> adapters that have SD support disabled? There are quite a few of those in the wild, as of right
> now (SD support is provided by bundled SDHCI on such systems, if at all). Similar argument goes
> for other media types as well - many controllers have xD support disabled too (I think you have
> one of those - Sony really values its customers). After all, it is not healthy to have dead code
> in the kernel.
>
A typical kernel config is an allmconfig, which has tones of dead
code: just see a 'General setup' part of your distro '.config'.
There are item like 'SMP' selected by default for 686+ CPUs. And
this is far more overhead that a single check of card type on
insert.

To allow customization, boolean module options that disable certain
card type may suffice.

And again, you are doing a great work with the driver.

--
Sergey Yanovich
