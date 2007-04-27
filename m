Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXD0W40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXD0W40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbXD0W4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:56:25 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63133 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbXD0W4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:56:23 -0400
Date: Fri, 27 Apr 2007 16:55:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: More than 2Gb problem (dvb related) ?
In-reply-to: <fa.pO/RoNmzgLz6KNMO4Ste8iezOk8@ifi.uio.no>
To: Gregoire Favre <Gregoire.Favre@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Message-id: <46327F5D.4060708@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.pO/RoNmzgLz6KNMO4Ste8iezOk8@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregoire Favre wrote:
> Hello,
> 
> I have a computer (mother Asus Commando) with 4x1Gb Ram.
> 
> If I start without the BIOS remap memory, my BIOS and linux just see 2Gb
> of ram, and DVB apps works just great.
> 
> When I enable the remapping of the memory, my BIOS and linux just see
> the whole 4Gb but then, I can tune to any transponder without problem,
> but I am unable to get a TS...
> 
> I have tested it with vdr/kaffeine/mplayer.
> 
> szap/kaffeine/vdr get the lock just well.
> 
> I had already asked about this on just linux-dvb ml, but maybe I am the
> first one to try DVB with a system with more than 2 Gb as I didn't
> receive any further info as someone get it working or not with such
> amount of ram.
> 
> Anyone got an idea on what could be done to solve this issue ?
> 
> PLEASE CC to me all message in lkml as I am not subscribed to this ml :)

Sounds like the cx88 driver is not using the DMA API properly to set up 
proper mappings, this will blow up if it tries to access memory above 
the 4GB mark if the device cannot do >32bit DMA..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

