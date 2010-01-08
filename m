Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541Ab0AHHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0AHHdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799Ab0AHHdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:33:49 -0500
Received: from dedale.eve-team.com ([194.79.182.190]:42700 "EHLO
	dedale.eve-team.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0AHHds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:33:48 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 02:33:48 EST
Message-ID: <4B46DD95.3030704@eve-team.com>
Date: Fri, 08 Jan 2010 08:24:05 +0100
From: Frederic Dumoulin <frederic_dumoulin@eve-team.com>
Organization: EVE
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: usage of memory reserved at boot time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to reserve 64MB of contiguous memory for DMA usage with a PCIe board, I'm using RHEL 5.4 and 2.6.18-164.el5.

I reserved this memory with the option memmap=64M$64M at boot-time.
I'd like to be sure that the reservation was succesful before remapping it in my module with ioremap,
Can I use something like check_mem_region ?


Thanks for your help.

Regards,

Frédéric

