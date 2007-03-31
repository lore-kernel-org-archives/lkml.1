Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXCaM4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXCaM4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 08:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXCaM4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 08:56:06 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:36954 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbXCaM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 08:56:05 -0400
Message-ID: <460E5A51.7010601@emc.com>
Date: Sat, 31 Mar 2007 08:55:45 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Mark Rustad <mrustad@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <4608B2B9.7090503@garzik.org> <ACBD2F44-03C7-49BE-9A2F-ABF7078BCC5E@gmail.com> <460964BA.8090101@garzik.org> <711F1620-F483-4CC2-83D6-F2DD577AB5BB@gmail.com>
In-Reply-To: <711F1620-F483-4CC2-83D6-F2DD577AB5BB@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.3.31.52133
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Rustad wrote:
> On Mar 27, 2007, at 1:38 PM, Jeff Garzik wrote:
>
>> Mark Rustad wrote:
>>> reorder any queued operations. Of course if you really care about 
>>> your data, you don't really want to turn write cache on.
>>
>> That's a gross exaggeration.  FLUSH CACHE and FUA both ensure data 
>> integrity as well.
>>
>> Turning write cache off has always been a performance-killing action 
>> on ATA.
>
> Perhaps. Folks I work with would disagree with that, but I am not 
> enough of a storage expert to judge. My statement mirrors the 
> judgement of folks I work with that know more than I do.

You can easily demonstrate that disabling write cache on a S-ATA or ATA 
drive will drop your large file write performance by 50% - just try 
writing 10MB files to disk. 

ric


