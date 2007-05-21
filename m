Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXEUH6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXEUH6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXEUH60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:58:26 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51885 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXEUH6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:58:25 -0400
Date: Mon, 21 May 2007 01:56:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
In-reply-to: <200705210741.l4L7fDJi006732@turbo.physics.adelaide.edu.au>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Message-id: <465150C2.4080006@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200705210741.l4L7fDJi006732@turbo.physics.adelaide.edu.au>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe wrote:
> I've just tried a quick test after enabling most of the PATA drivers under
> the libata section including the Jmicron driver (basically everything except
> those labelled "highly experimental").  As far as I can tell the
> CDROM/DVDROM is still not detected even with all these built into the
> kernel.  Maybe I do need one of those "highly experimental" drivers.

Can you post the entire lspci -v for this board?

> 
>> Also, it's unrelated to this problem, but you should check the BIOS 
>> settings for the SATA controller - you really want to get the controller 
>> into AHCI mode for best performance.
> 
> I've often wondered how the BIOS descriptions correlate with the modes the
> controller ends up in.  I've always gone for things like "enhanced" or
> "SATA" or "native" (the exact string of course being dependent on the BIOS
> writer's mood on the day).  This seems to work out OK in practice.  How
> can you tell from the Linux boot messages that the controller is in AHCI
> mode - is it as simple as looking for AHCI driver messages?  In this case
> the 
> 
>   scsi0 : ata_piix
>   scsi1 : ata_piix
> 
> indicate that things are suboptimal I assume.

Right, you should see that showing up as ahci.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


