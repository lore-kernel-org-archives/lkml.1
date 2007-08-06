Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbXHFXXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbXHFXXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762788AbXHFXXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:23:04 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:29460 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762192AbXHFXXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:23:01 -0400
Date: Mon, 06 Aug 2007 17:22:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Few interrupts with NO_HZ
In-reply-to: <fa.09fMUH3GW8WqIBDx7yLbNn+7hAo@ifi.uio.no>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <46B7AD4C.1020806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.09fMUH3GW8WqIBDx7yLbNn+7hAo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> this more of an informational question. So:
> 
> kernel version is 2.6.22.1 on i686
> 
> /proc/uptime 
> 9917.81 9140.90 (2h45m)
> 
> /proc/cpuinfo:
>            CPU0
>   0:        282   IO-APIC-edge      timer
> 
> this is kinda neat, I expected much more interrupts than just 282 since 
> boot. What kernel code actually uses the irq0 timer?

The kernel likely switched to using the local APIC timer after bootup..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

