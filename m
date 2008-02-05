Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYBESji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYBESji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYBESj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:39:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYBESj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:39:27 -0500
Message-ID: <47A8AD40.7010007@zytor.com>
Date: Tue, 05 Feb 2008 10:38:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, AAbdulla@nvidia.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org> <47A8A90B.6010602@garzik.org>
In-Reply-To: <47A8A90B.6010602@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> NAK - this fixes one set of users, and breaks a working set of users.
> 
> Need to add DMI check for the specific motherboard (dmi_check_system), 
> and flip flag according to success/failure of that check.
> 

Either that, or detect the Gigabyte prefix used as a suffix, since they 
seem to be the source of this particular f*ckup.

	-hpa
