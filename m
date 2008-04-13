Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYDMC3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYDMC3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYDMC3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 22:29:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:46112 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYDMC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 22:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tt1tYkFk+O410ehcsiDpsXgwZ7vtL0fZDq+lDLvJEQWiTSn15OqGlgLsGUMGfWPIPTWw9l+qQsc2o7h6fft2fG2bg1qrzzpbDLriRUIpxiSun9VtSGIVVsb7UFomImBu0swM9vKLEdtz9cgvrRB2bgm3A2Lxo1ke9/sXYyK8ls4=
Message-ID: <48016FF8.2050908@gmail.com>
Date: Sun, 13 Apr 2008 11:29:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Chaitanya Huilgol <chaitanya@tidaldata.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: ATA Bus Error with ICH7R and WDC WD7500AAKS-0
References: <47F38841.9080300@tidaldata.com> <20080402145628.c1eab7cb.akpm@linux-foundation.org>
In-Reply-To: <20080402145628.c1eab7cb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide)
> 
> On Wed, 02 Apr 2008 18:51:05 +0530
> Chaitanya Huilgol <chaitanya@tidaldata.com> wrote:
> 
>> Hi,
>>
>> I am getting frequent 'ATA bus error' with ICH7R & WD7500AAKS-0.
>> I have tried the following combinations of NCQ and Write Cache disabled,
>> Write I/O is done with dd:
>> dd if=/dev/zero of=/dev/sdc bs=1048576
>>
>> (1) With Write Cache is Disabled and NCQ is enabled then the
>> errors are seen immediately on starting I/O
>> (2) With Write Cache enabled and NCQ enabled the errors are less frequent
>> (3) With NCQ disabled using "echo 1 >/sys/block/sdc/device/queue_depth"
>> the errors are rare but do occur.
>>
>> I have tried with different SATA Cables & Sata port combinations to
>> rule out cable/bad port issues.
>>
>> I am wondering if the WDC WD7500AAKS-0 is another candidate for NCQ blacklist?

PHY RDY changed is likely to indicate hardware problems.  Especially so 
on ICH ahci's which is one of the best supported and tested.  Can you 
please re-seat cable and move the harddrive to different power connector?

-- 
tejun
