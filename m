Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbXKID3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbXKID3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 22:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXKID3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 22:29:40 -0500
Received: from rtr.ca ([76.10.145.34]:3343 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXKID3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 22:29:39 -0500
Message-ID: <4733D421.7000505@rtr.ca>
Date: Thu, 08 Nov 2007 22:29:37 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org>
In-Reply-To: <20071109023129.GA25581@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On Fri, Nov 09, 2007 at 09:02:35AM +0700, Riki Oktarianto wrote:
>> Some BIOSen map AHCI ABAR but lock the SATA controller to IDE mode.
>> This patch add quirk to set AHCI mode on ICH board with such case.
>>
>> Tested on Macbook2,1 (ICH7M)
> 
> Intel will complain but it's awful tempting...

*Very* tempting.

And I might even privately patch my own kernels to map the ACHI BAR
in the cases where the BIOS didn't...
