Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXITQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXITQew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbXITQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:34:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:50584 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbXITQel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KcXzbZy0XLCsuH+7Ai/VDzpEay1cZOwX+Ay0YnTDwMy4EfhLHTm+GZ9T0VX6t4llgIedT2FUIlxSQMan6lHAPw+4VORi5HCpBuOnA3OUKml3mLpxBjCgwtIkf6DamsPMp4PvbZOC5McWR1OCCktInX4AwNI/4tgVvWKKNf4igTk=
Message-ID: <46F2A122.8020909@gmail.com>
Date: Thu, 20 Sep 2007 20:34:42 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maciek Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Frans Pop <elendil@planet.nl>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba
 Satellite A40
References: <200709192014.08443.elendil@planet.nl> <20070920105312.GC12157@atrey.karlin.mff.cuni.cz> <200709201437.56431.elendil@planet.nl> <46F29965.8030603@gmail.com>
In-Reply-To: <46F29965.8030603@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciek Rutecki wrote:
> Frans Pop pisze:
>> On Thursday 20 September 2007, you wrote:
>>>> When compared with 2.6.22-4, dmesg no longer lists S4 and S5 as
>>>> supported for my Toshiba Satellite A40 laptop (Mobile Intel Pentium 4,
>>>> 2.8GHz).
>>>>
>>>> -Linux version 2.6.22-2-686 (Debian 2.6.22-4) (waldi@debian.org) ...
>>>> +Linux version 2.6.23-rc6 (root@faramir) ...
>>>>  [...]
>>>> -ACPI: (supports S0 S3 S4 S5)
>>>> +ACPI: (supports S0 S3)
>>> Unexpected, and potentially pretty serious. Something went wrong with
>>> ACPI. Can you try to narrow down when it started happening?
>> rc1 still had all 4 levels. I'll run a bisect between rc1 and rc6.
> 
> I have the same on HP/Compaq nx6310:
> ACPI: (supports S0 S3)
This is due to Rafael' split of suspend from hibernation. 
namely 296699de6bdc717189a331ab6bbe90e05c94db06.
Detection of S4 lacks printk(), so even if S4 is supported, it will not be reported.
Adding Rafael to the discussion :)

Regards,
Alex.

