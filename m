Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZBITvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZBITvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbZBITvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:51:25 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:58590 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZBITvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:51:25 -0500
Message-ID: <499088E7.8000206@free.fr>
Date: Mon, 09 Feb 2009 20:49:59 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 Iceape/1.1.14 (Debian-1.1.14-1)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net> <495A475D.7060608@panasas.com> <495B4ADB.3020904@panasas.com> <495D480F.3010208@free.fr>
In-Reply-To: <495D480F.3010208@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

matthieu castet wrote:
> Hi,
> 
> Boaz Harrosh wrote:
>> Hi Matthieu, Matthew
>>
>> I fixed lots of "mucking directly" with scsi_cmnd and scsi_eh_save
>> internal members but the actual set of srb->cmnd{,_len} is needed
>> still. Though we don't need the copy since we restore the original
>> command right after. If anyone can test this to verify it could
>> be grate.
>>
> your patch works for me.
> 
> Thanks and happy new year
> 
What's the status of that patch ?
I doesn't seem to be in stable nor master.


Matthieu
