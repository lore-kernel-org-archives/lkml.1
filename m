Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYBETPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYBETPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBETPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:15:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:2440 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYBETPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:15:05 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 14:15:05 EST
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 05 Feb 2008 11:09:53 -0800
Message-ID: <47A74C7E.8080101@nvidia.com>
Date: Mon, 04 Feb 2008 12:33:50 -0500
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org>	<47A8A90B.6010602@garzik.org> <20080205105909.fd8c6dbe.akpm@linux-foundation.org>
In-Reply-To: <20080205105909.fd8c6dbe.akpm@linux-foundation.org>
X-OriginalArrivalTime: 05 Feb 2008 19:08:59.0654 (UTC) FILETIME=[90286260:01C8682A]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Tue, 05 Feb 2008 13:20:59 -0500 Jeff Garzik <jeff@garzik.org> wrote:
> 
> 
>>>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>>NAK - this fixes one set of users, and breaks a working set of users.
>>
>>Need to add DMI check for the specific motherboard (dmi_check_system), 
>>and flip flag according to success/failure of that check.
> 
> 
> OK :)  I added the above to the changelog for next time.
> 
> You guys can hide, but this patch isn't going away!

I believe Michael determined that a newer BIOS fixes this issue.

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
