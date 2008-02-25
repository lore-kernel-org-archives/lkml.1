Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYBYWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYBYWXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYBYWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:23:21 -0500
Received: from rtr.ca ([76.10.145.34]:1457 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbYBYWXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:23:20 -0500
Message-ID: <47C34081.5090205@rtr.ca>
Date: Mon, 25 Feb 2008 17:26:09 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu, linux-ide@vger.kernel.org
Subject: Re: [ugly patch] Save .15W-.5W by AHCI powersaving
References: <20080225134558.GA1611@elf.ucw.cz>
In-Reply-To: <20080225134558.GA1611@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> This is a patch (very ugly, assumes you have just one disk) to bring
> powersaving to AHCI. You need Alan's SCSI autosuspend (attached) patch
> as a base.
> 
> It saves .5W compared to config with disk spinning, and even .15W
> compared to hdparm -y... on my thinkpad x60 anyway.
..

There was a discussion of this here today.
It makes good use of AHCI-specific features.

Has it been tested with a Port-Multiplier yet?

This is cool enough that we really ought to do a hardware-independent
version, so that all SATA interfaces could benefit.  Especially ata_piix,
but others too.

Cheers
