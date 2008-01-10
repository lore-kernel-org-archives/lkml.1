Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYAJAjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYAJAjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYAJAi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:38:57 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40676 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYAJAi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:38:56 -0500
Date: Wed, 09 Jan 2008 18:37:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80 I/O
 delay override.
In-reply-to: <fa.97XrGLIGlvAy4P/TB5vHHrfBrIw@ifi.uio.no>
To: "David P. Reed" <dpreed@reed.com>
Cc: Christer Weinigel <christer@weinigel.se>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@quramnet.com>, Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Message-id: <478568E3.6040409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.u5p8NBl8IjcycTVVtf0K+YtqNQc@ifi.uio.no>
 <fa.NOJkdyuk0c8CAqzZcG+pF1TzhJM@ifi.uio.no>
 <fa.YLAHN7jSUo9phsICUHnxilN7/lk@ifi.uio.no>
 <fa.SvgVgdNA9oz4F+tQ9MB2VRwr8ck@ifi.uio.no>
 <fa.By1MDYK0MY/fwkCWWrAiQCxl5KM@ifi.uio.no>
 <fa.97XrGLIGlvAy4P/TB5vHHrfBrIw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Christer Weinigel wrote:
>>
>> Did I miss anyting?
>>
>>   
> Nothing that seems *crucial* going forward for Linux.  The fate of
> "legacy machines" is really important to get right.
> 
> I have a small suggestion in mind that might be helpful in the future:
> the  "motherboard resources" discovered as PNP0C02 devices in their _CRS
> settings in ACPI during ACPI PnP startup should be reserved (or
> checked), and any drivers that still use port 80 implicitly should
> reserve that port.

I agree. In this case the BIOS on these laptops is trying to tell us 
"port 80 is used for our purposes, do not touch it". We should be listening.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

