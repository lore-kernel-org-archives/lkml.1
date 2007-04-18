Return-Path: <linux-kernel-owner+w=401wt.eu-S2992645AbXDROgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992645AbXDROgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992651AbXDROgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:36:24 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31527 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992645AbXDROgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:36:22 -0400
Date: Wed, 18 Apr 2007 08:35:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
In-reply-to: <fa.G71hHcdM3hwHRXkWS6Y2qKY+vVo@ifi.uio.no>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: max@duempel.org
Message-id: <46262CC9.7080909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.G71hHcdM3hwHRXkWS6Y2qKY+vVo@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> Yet another hard drive which doesn't seem to get NCQ right.
> 
>  ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl
>  0x1501000 status 0x400 next cpb count 0xB next cpb idx 0x0
>  [...]
>  ata1: timeout waiting for ADMA IDLE, stat=0x400
>  ata1: timeout waiting for ADMA LEGACY, stat=0x400
>  ata1.00: exception Emask 0x0 SAct 0x3fff SErr 0x200000 action 0x2
>  frozen
>  [...]
>  ata1: soft resetting port

Don't know if I noticed this before, but the controller seems to be 
reporting an SError, looks like a link layer CRC error. This could be a 
potential symptom of the drive and controller just not getting along, 
but you might want to try a different SATA cable as well.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

