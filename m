Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbYBETN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbYBETN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYBETNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:13:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47696 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbYBETNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:13:31 -0500
Message-ID: <47A8B558.7060605@garzik.org>
Date: Tue, 05 Feb 2008 14:13:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ayaz Abdulla <aabdulla@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org>	<47A8A90B.6010602@garzik.org> <20080205105909.fd8c6dbe.akpm@linux-foundation.org> <47A74C7E.8080101@nvidia.com>
In-Reply-To: <47A74C7E.8080101@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ayaz Abdulla wrote:
> Andrew Morton wrote:
>> On Tue, 05 Feb 2008 13:20:59 -0500 Jeff Garzik <jeff@garzik.org> wrote:
>>
>>
>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>
>>> NAK - this fixes one set of users, and breaks a working set of users.
>>>
>>> Need to add DMI check for the specific motherboard 
>>> (dmi_check_system), and flip flag according to success/failure of 
>>> that check.
>>
>>
>> OK :)  I added the above to the changelog for next time.
>>
>> You guys can hide, but this patch isn't going away!
> 
> I believe Michael determined that a newer BIOS fixes this issue.


That's a solution that makes vendors happy... but we still have to deal 
with it in Linux.  There are plenty of the old broken BIOS still out in 
the field...

	Jeff


