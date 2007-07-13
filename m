Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXGMFDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXGMFDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXGMFDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:03:16 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:1451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXGMFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=a1tk2V5uI5lfhUg3urKaqwmA+tsmssuMmcj1GlZizc6RgYIGtC0vKig08QEbnYSC3jDq7/gfnv+EeenzNxrLZPh0BTFkpHKMEVo9Y1m/vLCJ1sYv1vaT8Izm96BtIgxqTBrEFpaUN5G0hmx621QxxKnk+MtAgeBFU55DyOJY3ew=
Message-ID: <4697078D.4050601@gmail.com>
Date: Fri, 13 Jul 2007 14:03:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: YOSHIFUJI Hideaki / ???? <yoshfuji@linux-ipv6.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
References: <11841968512510-git-send-email-gregkh@suse.de>	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>	 <20070711235529.GA7485@suse.de>	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>	 <46959958.6080005@gmail.com> <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com> <4696FDDC.7050503@gmail.com>
In-Reply-To: <4696FDDC.7050503@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, forgot one thing.

Tejun Heo wrote:
>> I can't believe it should be so difficult to understand this. How can any
>> caller (that first did a xxx_get() on that shared object) land up with that
>> object getting NULL _from under it_ unless some logic is wrong
>> somewhere? And instead of flagging this broken logic, the proposed
>> change here would hide it.

I agree with you about get().  Allowing NULL argument doesn't really
help anything.  It only increases the chance of getting things wrong.
I'm all for not allowing NULL argument to get().  For put(), as I wrote
before, I think allowing NULL has some advantages and I don't care
either way as long as it's not confusing.  The 'not confusing' part is
way more important to me than advantages of either way.

-- 
tejun
