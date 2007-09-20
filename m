Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXITQeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXITQeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbXITQdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:33:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:49528 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXITQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nrhop6G7IRB7+IG82rwhZ9yCdxsVvtpFMHDWRsL7J/dR2hm5bhy8RLKtvxqrtcq6+Is+vkrfujE4AqzwLpkuxv8IRlWFs0w5QpPRcpVWaU+uEEDdEKt1QUhq/mGdKIUV98g5UqoYzmkWb1V70ze43TzFOQKBcIvLsp1SmByq47M=
Message-ID: <46F2A0E9.9000603@gmail.com>
Date: Thu, 20 Sep 2007 18:33:45 +0200
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
>>>  [...]
>>> -ACPI: (supports S0 S3 S4 S5)
>>> +ACPI: (supports S0 S3)
>> Unexpected, and potentially pretty serious. Something went wrong with
>> ACPI. Can you try to narrow down when it started happening?
> 
> rc1 still had all 4 levels. I'll run a bisect between rc1 and rc6.

2.6.23-rc1 OK (supports S0 S3 S4 S5)
2.6.23-rc2 wrong: (supports S0 S3)
