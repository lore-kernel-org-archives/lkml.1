Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYKJIMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYKJIMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYKJIMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:12:32 -0500
Received: from smtp.nokia.com ([192.100.122.233]:47969 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYKJIMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:12:31 -0500
Message-ID: <4917EEC7.3070701@nokia.com>
Date: Mon, 10 Nov 2008 10:20:23 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
References: <48F7411F.3020109@nokia.com> <20081026121155.69692474@mjolnir.drzeus.cx> <49083B1C.6060803@nokia.com>
In-Reply-To: <49083B1C.6060803@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 08:12:20.0737 (UTC) FILETIME=[0DD2FF10:01C9430C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter wrote:
> Add command response and card status to error
> messages.
> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
> drivers/mmc/card/block.c |   56 
> ++++++++++++++++++++++++++++++++++++++++-----
> 1 files changed, 49 insertions(+), 7 deletions(-)
> 
> 
> Pierre
> 
> This patch amends error messages for all error codes and is independent 
> of SPI.
> Status values are not OR'd together from different commands as that would
> muddy the waters for anyone trying to understand the nature of the error.
> Waiting for the card to become ready after an error is also not included,
> as it is not in the standards and is a separate issue anyway.
> 
> Regards
> Adrian

What is the status of this patch?

