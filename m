Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYAJAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYAJAs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAJAsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:48:19 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:40086 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYAJAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:48:18 -0500
Message-ID: <47856A69.1090500@keyaccess.nl>
Date: Thu, 10 Jan 2008 01:44:25 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "David P. Reed" <dpreed@reed.com>,
       Christer Weinigel <christer@weinigel.se>,
       Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@quramnet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <fa.u5p8NBl8IjcycTVVtf0K+YtqNQc@ifi.uio.no> <fa.NOJkdyuk0c8CAqzZcG+pF1TzhJM@ifi.uio.no> <fa.YLAHN7jSUo9phsICUHnxilN7/lk@ifi.uio.no> <fa.SvgVgdNA9oz4F+tQ9MB2VRwr8ck@ifi.uio.no> <fa.By1MDYK0MY/fwkCWWrAiQCxl5KM@ifi.uio.no> <fa.97XrGLIGlvAy4P/TB5vHHrfBrIw@ifi.uio.no> <478568E3.6040409@shaw.ca>
In-Reply-To: <478568E3.6040409@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-01-08 01:37, Robert Hancock wrote:

> David P. Reed wrote:

>> I have a small suggestion in mind that might be helpful in the future:
>> the  "motherboard resources" discovered as PNP0C02 devices in their _CRS
>> settings in ACPI during ACPI PnP startup should be reserved (or
>> checked), and any drivers that still use port 80 implicitly should
>> reserve that port.
> 
> I agree. In this case the BIOS on these laptops is trying to tell us 
> "port 80 is used for our purposes, do not touch it". We should be 
> listening.

Listening is fine but what are you going to do after you have listened? 
Right, not use port 0x80 but since that's the current idea anyway outside of 
legacy drivers, you don't actually need to listen.

If the quirk-to-0xed or similar was to stay, it's a much better switching 
point than DMI strings but if not, it's not actually important.

Rene.
