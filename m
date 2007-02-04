Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXBDRjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXBDRjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXBDRjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:39:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31655 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXBDRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:39:10 -0500
Date: Sun, 04 Feb 2007 11:38:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: More pata_ stuff
In-reply-to: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
To: Patrick Ale <patrick.ale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45C619FC.3040804@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> Hi,
> 
> I tried to use the new pata drivers on a Dual PII-400Mhz with the
> Intel PIIX controller.
> 
> Unfortunately the controller doesn't get detected on boot time, the
> old IDE drivers do work and see the controller as a PIIX4 chipset,
> which is correct.
> 
> The mainboard is a Asus P2B with integrated Adaptec SCSI host and the
> PIIX controller.

ata_piix should drive that chipset. Was that driver enabled in the 
kernel configuration, and if it's built modular is the initrd, etc. set 
up to load it on boot?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

