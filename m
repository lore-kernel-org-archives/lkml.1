Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYAIB4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYAIB4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYAIB4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:56:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:46601 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYAIB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:56:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P2n/LIOWfkg2iuOkizFs37Ggo58DSruTimYkRZP+acveahuFeF4j4hBzvn4qBMuxh7GZEQKCHyF9fVlabHakfz2C5h/VCKAg+47fXQbZPeXpcIp+cbbSHzVlgz7rCNFxtQoB0Vj1+o5vvkpqxIqedkVUn472yh7HDqUyw/f2a8I=
Message-ID: <478429B2.2030002@gmail.com>
Date: Wed, 09 Jan 2008 10:56:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <20080108015012.2e518dd4@werewolf>
In-Reply-To: <20080108015012.2e518dd4@werewolf>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> HI all...
> 
> On Sun, 6 Jan 2008 14:19:16 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> It's been two weeks since rc6, but let's face it, with xmas and new years 
>> (and birthdays) in between, there hasn't actually been a lot of working 
>> days, and the incremental patch from -rc6 is about half the size of the 
>> one from rc5->rc6.
>>
>> And I'll be charitable and claim it's because it's all stabilizing, and 
>> not because we've all been in a drunken stupor over the holidays.
>>
>> The shortlog (appended below) is short and fairly informative. It's all 
>> really just a lot of rather small changes. The diffstat shows a lot of 
>> one- and two-liners, with just a few drivers (and the Cell platform) 
>> getting a bit more attention, and the SLUB support of /proc/slabinfo 
>> showing up as a blip.
>>
> 
> With this kernel I'm getting frequent temporary freezes (system comes
> back responsive after a minute or so...). I see this in dmesg:
> 
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata3.00: cmd ca/00:08:67:10:18/00:00:00:00:00/e2 tag 0 dma 4096 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata3.00: status: { DRDY }
> ata3: soft resetting link
> ata3.00: configured for UDMA/133
> ata3: EH complete
> sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata4.00: cmd c8/00:08:ef:0b:c7/00:00:00:00:00/e7 tag 0 dma 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata4.00: status: { DRDY }
> ata4: soft resetting link
> ata4.00: configured for UDMA/133
> ata4: EH complete
> sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
> sd 3:0:0:0: [sdc] Write Protect is off
> sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> See this are two different drives, I doubt both drives have gone nuts
> at the same time...

That's weird.  There hasn't been any related changes.  Does going back
to 2.6.24-rc6 fix the problem?

-- 
tejun
