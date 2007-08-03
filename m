Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbXHCWoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbXHCWoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbXHCWn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:43:57 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63488 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760321AbXHCWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:43:56 -0400
Date: Fri, 03 Aug 2007 16:43:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: snd-au8830: dead after software suspend
In-reply-to: <fa.d+lo4WW9OJY+C4dt2t6vRieik2I@ifi.uio.no>
To: Gert Robben <lkml@gert.robben.nu>
Cc: linux-kernel@vger.kernel.org
Message-id: <46B3AF86.1070800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.d+lo4WW9OJY+C4dt2t6vRieik2I@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gert Robben wrote:
> After a suspend-resume cycle (using Suspend2), my sound card doesn't 
> work anymore. It works again after reloading the module.
> 
> dmesg, initial boot:
>> Linux version 2.6.22-ck1
> ----8<----
>> PCI driver au8830 lacks driver specific resume support.
> 
> dmesg, after resume, trying to use the card:
>> vortex: ac97 codec stuck busy
> 
> Thanks for any help!

That driver will have to be updated to reinitialize the card properly 
after resume.. Have you reported this to the ALSA people?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

