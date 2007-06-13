Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXFMSDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXFMSDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbXFMSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:03:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:56316 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbXFMSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=cOMK4IE6d7/9uNfGAZWnrXk98DBNx6PJG0As3tKAcOCm8C4oS25+iGtu/LQ3CWKc2vRBEVPcJL9xG2iDNQiBcxUwtDDjpt2Csa0ohLEdrUAoAi/XF4jdJmsu+fS0BVM/wgQYgQKJDlopQPML3shoT/PPMu8lMOz7jfHhKggAEck=
Message-ID: <4670311C.4080505@googlemail.com>
Date: Wed, 13 Jun 2007 20:02:04 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [1/3] 2.6.22-rc4: known regressions v2
References: <466AE606.7020704@googlemail.com>	<20070612150221.GB5986@ucw.cz> <20070613075110.0a9f54c2.akpm@linux-foundation.org>
In-Reply-To: <20070613075110.0a9f54c2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> On Tue, 12 Jun 2007 15:02:22 +0000 Pavel Machek <pavel@ucw.cz> wrote:
> 
>> Hi!
>>
>> Can we add 'writing to /proc/acpi/thermal/*/trip_points' no longer
>> works to the list?
> 
> I thought we had.

Len rejected this bug
http://bugzilla.kernel.org/show_bug.cgi?id=8495

> 
>> Len did it intentionally but that does not make it
>> right. People are using it and we did not go through deprecation
>> period. Plus there's no reasonable alternative.
> 
> Was that writeability causing any actual problems in 2.6.21?
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
