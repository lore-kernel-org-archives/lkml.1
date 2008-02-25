Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbYBYWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbYBYWnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYBYWnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:43:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36324 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbYBYWnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:43:05 -0500
Message-ID: <47C34472.3090706@garzik.org>
Date: Mon, 25 Feb 2008 17:42:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu, linux-ide@vger.kernel.org
Subject: Re: [ugly patch] Save .15W-.5W by AHCI powersaving
References: <20080225134558.GA1611@elf.ucw.cz> <47C34081.5090205@rtr.ca>
In-Reply-To: <47C34081.5090205@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Pavel Machek wrote:
>> This is a patch (very ugly, assumes you have just one disk) to bring
>> powersaving to AHCI. You need Alan's SCSI autosuspend (attached) patch
>> as a base.
>>
>> It saves .5W compared to config with disk spinning, and even .15W
>> compared to hdparm -y... on my thinkpad x60 anyway.
> ..
> 
> There was a discussion of this here today.
> It makes good use of AHCI-specific features.
> 
> Has it been tested with a Port-Multiplier yet?
> 
> This is cool enough that we really ought to do a hardware-independent
> version, so that all SATA interfaces could benefit.  Especially ata_piix,
> but others too.

BTW we can also save power by allowing the user to choose to disable 
hotplugging support.  Then we can power down PHYs that are not in use.

That requires the addition of some policy controls, because it is 
user-specific whether or not to waste power waiting for a plug-in event.

	Jeff



