Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXA3XOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXA3XOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXA3XOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:14:53 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:36434 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXA3XOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:14:52 -0500
Date: Tue, 30 Jan 2007 17:12:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble with
 mass storage devices ?!
In-reply-to: <fa.SlST1aKbNgZSghdvI9esD81kVnI@ifi.uio.no>
To: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>
Message-id: <45BFD0F6.9040201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PeThxrKzzfWoGYao97lEVEZgJlc@ifi.uio.no>
 <fa.SlST1aKbNgZSghdvI9esD81kVnI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:

> The log revealed that the phone's firmware returns garbage values in the 
> Residue field for some WRITEs.  This patch should take care of it.
> 
> Alan Stern

Is it just me, or should some of these device quirk entries that keep 
being added be made unconditional? Adding entries for every single 
device that shows up with these problems seems like not a very scalable 
approach. These devices obviously work in Windows, can't we just emulate 
its behavior here?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

