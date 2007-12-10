Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXLJO4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXLJO4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXLJOzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:55:54 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:49872 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753166AbXLJOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:55:53 -0500
Date: Mon, 10 Dec 2007 15:55:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ed Sweetman <safemode2@comcast.net>
Cc: Mike Houston <mikeserv@bmts.com>, Elvis Pranskevichus <el@prans.net>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Message-ID: <20071210155550.1844b561@hyperion.delvare>
In-Reply-To: <475C9739.4030306@comcast.net>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209000554.GF20441@stusta.de>
	<20071208212234.e00b74cd.mikeserv@bmts.com>
	<20071209105028.06ed52a6@hyperion.delvare>
	<E1J1TRp-0000ZF-6J@asgard.prans.org>
	<20071209234215.748ed407@hyperion.delvare>
	<20071209191959.eba5a41f.mikeserv@bmts.com>
	<475C9739.4030306@comcast.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

On Sun, 09 Dec 2007 20:32:41 -0500, Ed Sweetman wrote:
> I'm seeing this exact problem on an Asus Nforce4 based board. Prior to 
> moving to 2.6.24-rc4 it worked just fine.  No additional acpi options 
> were selected in kernel config.  
> 
> So add Asus A8N-E to the list of broken pnpacpi

For the records, can you please paste the offending lines (from the
boot logs or /proc/ioports)?

Then please give a try to Shaohua's patch and report:
http://lkml.org/lkml/diff/2007/12/9/186/1

Thanks,
-- 
Jean Delvare
