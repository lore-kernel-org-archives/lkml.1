Return-Path: <linux-kernel-owner+w=401wt.eu-S1767310AbXECBeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767310AbXECBeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 21:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767311AbXECBeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 21:34:21 -0400
Received: from hoemail2.lucent.com ([192.11.226.163]:58026 "EHLO
	hoemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767310AbXECBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 21:34:20 -0400
Message-ID: <46393BF9.8090408@alcatel-lucent.com>
Date: Thu, 03 May 2007 09:33:45 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: It's a bug of printk?
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>  <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>  <20070502221045.ad20b915.diegocg@gmail.com> <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com> <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2007 01:33:38.0099 (UTC) FILETIME=[12BB6030:01C78D23]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need 2 consoles for 2 individual serial ports that is registered by 
register_console(). The console for the 1st serial port is registered at 
first. I can see the output from the serial port #1 before the console 
for the 2nd serial port is registered. However, I saw duplicated output 
from serial port #1 again after the console for #2 serial port is 
registered.

The root cause is that there is only one con_start for all consoles. I 
think con_start need to be merged with struct console so that different 
console could have different start?

Thanks,
Gavin
