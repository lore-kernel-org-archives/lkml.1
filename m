Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbXB1XUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbXB1XUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXB1XUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:20:50 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:32278 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbXB1XUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:20:49 -0500
Date: Wed, 28 Feb 2007 17:20:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: solved Re: 2.6.20 SATA error
In-reply-to: <fa.Evhbh+iC4EjQWXsDSWHX9shqJXc@ifi.uio.no>
To: Gerhard Mack <gmack@innerfire.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Charles Shannon Hendrix <shannon@widomaker.com>
Message-id: <45E60E36.2070709@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
 <fa.OO5sHloeJxxBmHwyt7Swo5eydUY@ifi.uio.no>
 <fa.G7ZWCF8iZMzCCHcWS6votbmzA3U@ifi.uio.no>
 <fa.GSOUb36DPlkk7gFXS5FtJVpQIq0@ifi.uio.no>
 <fa.Evhbh+iC4EjQWXsDSWHX9shqJXc@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> On Wed, 28 Feb 2007, Charles Shannon Hendrix wrote:
> 
>> On Wed, 28 Feb 2007 13:25:00 -0500 (EST)
>> Gerhard Mack <gmack@innerfire.net> wrote:
>>
>>  
>>>> In another thread, I think they were saying it was either a SATA chipset
>>>> driver bug, or a problem in libata core.
>>> I also have an nforce4.
>> On another mailing list, someone with an Intel chipset is reporting the same
>> problem, and also that others without nforce chipsets are seeing it.
> 
> I was reaching inside my computer to check something and heared the thing 
> click and got the same error message.
> 
> Turns out the adaptor that goes between SATA drive and the old style power 
> connector was loose on the drive side.  Doesn't seem to me like it was 
> very snug fitting to begin with.  I changed it to one of the proper SATA 
> connectors comming off the power supply and it doesn't do that anymore.
> 
> Sorry for the false alarm, 

There is one thing that seems odd, if you do have an nForce4 chipset, 
the kernel should be running the SATA controller in ADMA mode in 2.6.20, 
but it doesn't seem like it is from your dmesg output. Can you post the 
output of "lspci -vvn"? Also what kind of motherboard is that?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

