Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbXEaSI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbXEaSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXEaSIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:08:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:12356 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbXEaSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=pKm4to0bdKt32ZYaeDyDHudBBBbscEPof3L+Dd8ddgBFCGybhqpi9Z83gI5Fop0XuvUfRiX8fp5t1yRKtvfzdQYD2NF0Jq+UHOj2O11XQTcyoiYajkLyKpL2THIrE29pHEYCSJiQa0VBkN8rrOhv9iQy36bMsQIk2kzZ0hXcF2s=
Message-ID: <465F0F02.7070308@googlemail.com>
Date: Thu, 31 May 2007 20:08:02 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <465F0B83.2050100@googlemail.com>
In-Reply-To: <465F0B83.2050100@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> Andrew Morton napisał(a):
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
>>
> 
> CPU hotplug test triggered this
> 
> [ 4972.038008] CPU 1 is now offline
> [ 4972.041411] lockdep: not fixing up alternatives.
> [ 4972.051553] 
> [ 4972.051555] =================================
> [ 4972.057562] [ INFO: inconsistent lock state ]
> [ 4972.062056] 2.6.22-rc3-mm1 #10
> [ 4972.065184] ---------------------------------
[..]
> [ 4972.372562]  =======================
> [ 4975.412963] lockdep: not fixing up alternatives.
> 
> Suspects:
> add-suspend-related-notifications-for-cpu-hotplug-statistics.patch

not guilty

> cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

not guilty

> cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch

not guilty

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
