Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXITQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXITQDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXITQDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:03:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbXITQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EBlCRPLR0beBmolHaGRSEW/XMyHvoXKPGFL/sdUGWNWSevVXphquaH4TxVmKHz6C4Y4OZr2B/xQn43wFLvZZTfY9Do2y3CmdwQqJczauSuOhtBBcbR3r1VnXkhUdCyVw58HW+WDQ3QIMcOzp/6O3QHP0pSevnW/SR4K/ukOFGWI=
Message-ID: <46F29965.8030603@gmail.com>
Date: Thu, 20 Sep 2007 18:01:41 +0200
From: Maciek Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba
 Satellite A40
References: <200709192014.08443.elendil@planet.nl> <20070920105312.GC12157@atrey.karlin.mff.cuni.cz> <200709201437.56431.elendil@planet.nl>
In-Reply-To: <200709201437.56431.elendil@planet.nl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop pisze:
> On Thursday 20 September 2007, you wrote:
>>> When compared with 2.6.22-4, dmesg no longer lists S4 and S5 as
>>> supported for my Toshiba Satellite A40 laptop (Mobile Intel Pentium 4,
>>> 2.8GHz).
>>>
>>> -Linux version 2.6.22-2-686 (Debian 2.6.22-4) (waldi@debian.org) ...
>>> +Linux version 2.6.23-rc6 (root@faramir) ...
>>>  [...]
>>> -ACPI: (supports S0 S3 S4 S5)
>>> +ACPI: (supports S0 S3)
>> Unexpected, and potentially pretty serious. Something went wrong with
>> ACPI. Can you try to narrow down when it started happening?
> 
> rc1 still had all 4 levels. I'll run a bisect between rc1 and rc6.

I have the same on HP/Compaq nx6310:
ACPI: (supports S0 S3)

(kernel 2.6.23-rc6)

But suspend to ram/disk works.

