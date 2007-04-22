Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXDVXvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXDVXvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161148AbXDVXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:51:07 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:54998 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbXDVXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:51:06 -0400
Date: Sun, 22 Apr 2007 17:50:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
In-reply-to: <fa.2kDN6AWFnkWM37pP5//wKJmbvRQ@ifi.uio.no>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <462BF4DF.7080401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2kDN6AWFnkWM37pP5//wKJmbvRQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda wrote:
> Hi all,
> 
> I have a ASUS P4P800 Deluxe, P4 3GHz HT, 1GB RAM and testing -rc7 I
> noticed I just got 1 CPU.
> 
> I checked my .config but I do not see anything bad. Also I read
> Documentation/smp.txt. Just for being sure this is not a bug, I'm
> posting it.
> 
> Here you have .config and dmesg.

You didn't enable ACPI, it's needed for almost all systems to detect HT 
and also for many systems to detect multi-cores as well.

Aside from that, in general I would say that on any modern x86 system 
ACPI should always be enabled. In many cases it seems the BIOS code is 
not tested much without ACPI anymore, so going without ACPI can be 
problematic.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

