Return-Path: <linux-kernel-owner+w=401wt.eu-S1764966AbYBVV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764966AbYBVV17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYBVV1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:27:50 -0500
Received: from rtr.ca ([76.10.145.34]:1654 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbYBVV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:27:49 -0500
Message-ID: <47BF3E54.9050609@rtr.ca>
Date: Fri, 22 Feb 2008 16:27:48 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org>
In-Reply-To: <20080222200951.GI16995@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> I've ported the scsi_ram driver [1] to libata.  It could use a lot more
> work -- there's a lot of stuff in the identify page that I haven't
> filled in, and there's a lot of commands it doesn't even try to execute.
> 
> For example, when you unload the driver, you get the mildly disturbing
> messages:
> 
> sd 12:0:0:0: [sdb] Stopping disk
> sd 12:0:0:0: [sdb] START_STOP FAILED
> sd 12:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> 
..

I see messages like those with *established* libata drivers from time to time.
It could just be a bug in the shutdown sequence, somewhere between libata,
SCSI, block layer, and the device model in general.  Or not.

Cheers
