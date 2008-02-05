Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYBESmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYBESmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYBESmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:42:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44163 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbYBESmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:42:06 -0500
Message-ID: <47A8ADF9.7060507@garzik.org>
Date: Tue, 05 Feb 2008 13:42:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, AAbdulla@nvidia.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org> <47A8A90B.6010602@garzik.org> <47A8AD40.7010007@zytor.com>
In-Reply-To: <47A8AD40.7010007@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>>>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>> NAK - this fixes one set of users, and breaks a working set of users.
>>
>> Need to add DMI check for the specific motherboard (dmi_check_system), 
>> and flip flag according to success/failure of that check.
>>
> 
> Either that, or detect the Gigabyte prefix used as a suffix, since they 
> seem to be the source of this particular f*ckup.

Indeed, that would work too...  though we would need to put out a call 
for Gigabyte testers during 2.6.25-rc.

It is an entirely reasonable scenario for NVIDIA to deploy a fix to 
Gigabyte, which would then return us to the same scenario we have today: 
  some work and some don't.

That's my main reason for leaning more conservative here.

	Jeff




