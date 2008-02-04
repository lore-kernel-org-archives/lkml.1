Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYBETeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYBETeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYBETeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:34:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:4522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbYBETeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:34:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 05 Feb 2008 11:33:34 -0800
Message-ID: <47A751F6.3030007@nvidia.com>
Date: Mon, 04 Feb 2008 12:57:10 -0500
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org>	<47A8A90B.6010602@garzik.org> <20080205105909.fd8c6dbe.akpm@linux-foundation.org> <47A74C7E.8080101@nvidia.com> <47A8B558.7060605@garzik.org>
In-Reply-To: <47A8B558.7060605@garzik.org>
X-OriginalArrivalTime: 05 Feb 2008 19:32:13.0154 (UTC) FILETIME=[CEBF9C20:01C8682D]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jeff Garzik wrote:
> Ayaz Abdulla wrote:
> 
>> Andrew Morton wrote:
>>
>>> On Tue, 05 Feb 2008 13:20:59 -0500 Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>>
>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>
>>>>
>>>> NAK - this fixes one set of users, and breaks a working set of users.
>>>>
>>>> Need to add DMI check for the specific motherboard 
>>>> (dmi_check_system), and flip flag according to success/failure of 
>>>> that check.
>>>
>>>
>>>
>>> OK :)  I added the above to the changelog for next time.
>>>
>>> You guys can hide, but this patch isn't going away!
>>
>>
>> I believe Michael determined that a newer BIOS fixes this issue.
> 
> 
> 
> That's a solution that makes vendors happy... but we still have to deal 
> with it in Linux.  There are plenty of the old broken BIOS still out in 
> the field...
> 
>     Jeff
> 
> 

Michael, can you provide which BIOS version had this issue and which 
version fixed the issue?



-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
