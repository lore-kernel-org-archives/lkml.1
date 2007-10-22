Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXJVWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXJVWB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXJVWBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:01:50 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:52449 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXJVWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:01:49 -0400
Message-ID: <471D1DC8.5090802@freescale.com>
Date: Mon, 22 Oct 2007 17:01:44 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: request_firmware() and in-kernel modules
References: <4718EAEA.9000609@freescale.com> <20071021040757.GC24869@kroah.com>
In-Reply-To: <20071021040757.GC24869@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> I'd recommend using the non-blocking mode, that way, when userspace
> finally gets running, it can handle the firmware events properly, and
> your kernel code will have not timed out already.

Thanks Greg, that did the trick.

What the value of FW_ACTION_NOHOTPLUG?  If I specify that instead of 
FW_ACTION_HOTPLUG, I presume I don't get automatic loading of the firwmare via 
the hotplug subsystem, but request_firmware() still times out.  Why would I ever 
not want to take advantage of hotplug?

