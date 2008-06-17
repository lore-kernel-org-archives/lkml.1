Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYFQATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYFQATz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYFQATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:19:46 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63005 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFQATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:19:45 -0400
Date: Mon, 16 Jun 2008 18:19:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [regression] display dimming is slow and laggy
In-reply-to: <fa.bYtHs6zUqCWUnOriVTRy2wrCy7s@ifi.uio.no>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <485702F7.6060704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.bYtHs6zUqCWUnOriVTRy2wrCy7s@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maximilian Engelhardt wrote:
> Hello,
> 
> I'm using kernel 2.6.26-rc6 at the moment and with it dimming the display is 
> slow and laggy. Using kernel 2.6.25 doesn't show this problem.
> 
> Here is a more detailed explanation:
> 
> I'm dimming my display with the appropriate keys on my laptop (Fn + 
> right/left). Till kernel 2.6.25 this has worked without any problems. Now I'm 
> using 2.6.26-rc6 and using the keys the display is dimming much slower and 
> also laggy. By laggy I mean if I hit the keys for increasing/decreasing 
> brightness it starts dimming and when I release the keys after some time it 
> still continues dimming for some steps.
> 
> My laptop is a Acer Travelmate 661lci and has an Intel 855 chipset.
> 
> I'll attach my dmesg output, please tell me if you need any further 
> information.

Think you forgot the dmesg. Are you seeing a "ACPI: EC: GPE storm 
detected, disabling EC GPE" message? See:

http://bugzilla.kernel.org/show_bug.cgi?id=10724

This seems to affect a lot of Acer laptops.
