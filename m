Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXCAAWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXCAAWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCAAWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:22:38 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64876 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbXCAAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:22:37 -0500
Date: Wed, 28 Feb 2007 18:21:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20 SATA error
In-reply-to: <Pine.LNX.4.64.0702281825200.11020@mtl.rackplans.net>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Charles Shannon Hendrix <shannon@widomaker.com>
Message-id: <45E61C9C.4080401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
 <fa.OO5sHloeJxxBmHwyt7Swo5eydUY@ifi.uio.no>
 <fa.G7ZWCF8iZMzCCHcWS6votbmzA3U@ifi.uio.no>
 <fa.GSOUb36DPlkk7gFXS5FtJVpQIq0@ifi.uio.no>
 <fa.Evhbh+iC4EjQWXsDSWHX9shqJXc@ifi.uio.no> <45E60E36.2070709@shaw.ca>
 <Pine.LNX.4.64.0702281825200.11020@mtl.rackplans.net>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
>>> Sorry for the false alarm, 
>> There is one thing that seems odd, if you do have an nForce4 chipset, the
>> kernel should be running the SATA controller in ADMA mode in 2.6.20, but it
>> doesn't seem like it is from your dmesg output. Can you post the output of
>> "lspci -vvn"? Also what kind of motherboard is that?
>>
> Sure thing.  It's an Asus m2npv-vm.

Ah, that would be why, it's not one of the original nForce4 
(CK804/MCP04) chipsets, it's the newer nForce 430 (MCP51) chipset which 
doesn't support ADMA. NVidia said they'd be sending some patches to 
allow NCQ support on MCP51 and MCP61 chipsets back in October, but I 
haven't seen any, or information required to implement same..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


