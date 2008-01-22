Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYAVBSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYAVBSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYAVBSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:18:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYAVBR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:17:59 -0500
Message-ID: <479541F5.9080705@zytor.com>
Date: Mon, 21 Jan 2008 17:08:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
References: <20080121231557.GA4025@spacedout.fries.net>
In-Reply-To: <20080121231557.GA4025@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> The ds18b20 one wire temperature sensor conversion routine is
> returning the units in degrees C while the ds1820 (ds18s20) is
> returning it in .001 degrees C.  20C vs 20312C.  Once you know the
> units I'm liking the latter as it gives a higher precision.  Time to
> break user applications so the driver can give the temperature in the
> same units for both sensors.
> 
> I only have the ds18b20 sensor model.  Here is the current output from
> the sys file for this sensor.
> /sys/devices/w1_bus_master1/28-0000000e84a2/w1_slave
> 45 01 4b 46 7f ff 0b 10 84 : crc=84 YES
> 45 01 4b 46 7f ff 0b 10 84 t=20
> 
> I ran the example data from the specification for the ds1820 through
> it's conversion routine and found that t= was 1000 times the value.  
> What should the displayed units be?  
> 
> This is the same ds18b20 conversion *1000.  Is everyone ok or is any
> objecting to .001 degrees C for the units?  Patch will follow.  The
> .001 C does truncate one bit of precision from the ds18b20 by the way.
> 

Millikelvins would have the nice property of never being negative.  :)

	-hpa
