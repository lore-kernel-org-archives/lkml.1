Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYFKSj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYFKSj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYFKSjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:39:48 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:56586 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYFKSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WRr6RwkhlB8xUXmsPC9qVqMqDCwbVBiVUGsSJ6JrBpzSoirgrN1owMoUKcHXLt7Is+
         t2Aif9TlQArQANWBawt1oO4mD6Ov19GhRUSe2WEtGCzQ8jtzEVSTE6QqlSv2cCs8mQqI
         UL1EkBVjxkFIyXX+24qZ/yAO5H6zmmQMrShKE=
Message-ID: <dd18b0c30806111139o2cb0f61m9b0bc2a1f1f4df00@mail.gmail.com>
Date: Wed, 11 Jun 2008 18:39:45 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Pavel Machek" <pavel@suse.cz>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <484FA90F.3010005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>
	 <20080606235526.783acc83.akpm@linux-foundation.org>
	 <dd18b0c30806070847t63b8dbc0x8bfcbafc359f7031@mail.gmail.com>
	 <484AE148.6000204@suse.de> <20080608142106.GD4739@ucw.cz>
	 <484FA90F.3010005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 10:29 AM, Alexey Starikovskiy
<aystarik@gmail.com> wrote:
> Pavel Machek wrote:
>>
>> Hi!
>>
>> On Sat 2008-06-07 23:28:08, Alexey Starikovskiy wrote:
>>
>>>
>>> Justin Mattock wrote:
>>>
>>>>
>>>> On Sat, Jun 7, 2008 at 6:55 AM, Andrew Morton
>>
>>
>>>>
>>>> This issue just recently started, 2.6.25-rc9 and below don't give me
>>>> this message.
>>>>
>>>>
>>>
>>> Yes, the problem which we are fighting here is that almost all Acer
>>> notebooks come with
>>> broken EC. It sends interrupts not regarding the fact that we already
>>> ACKed it.
>>> It comes unnoticed on almost all machines (some notice laggy keyboard,
>>> because it's the same controller after all and it's busy with sending ACPI
>>> interrupts and then providing same status byte over and over), but on some
>>> machines keystrokes become missing, which is not tolerable (#9998).
>>>
>>
>> But the acer workaround breaks other machines, right?
>>
>>
>
> As I know, the first workaround broke your machine,
> may be you could check if it is broken now?
>>
>> So what about
>>
>> a) use dmi blacklist for acers?
>>
>>
>
> It is not only Acers. ASUS eeePC is known to be affected, some Apple
> notebook too.
>>
>> or
>>
>> b) if EC storm is detected print message telling 'please pass
>> ec_polled=true if you experience keyboard problems', but do nothing
>> else?
>>
>>
>
> There are no reports about broken machines for 2.6.26-rc5 beside #10724,
> which has same broken controller, sending same amount of stray interrupts.
> If there will be report from a good machine affected by this workaround then
> I will
> certainly go with b)
>
> Thanks,
> Alex.
>
>
>

FWIW: just to let you guys know over here with a Macbook Pro ATI
chipset, as a small test removing the battery
I did not receive this message after 5+ hours of uptime. Normally on a
good run with the battery attached I get around an hour or so before
this triggers.
regards;

-- 
Justin P. Mattock
