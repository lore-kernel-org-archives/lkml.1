Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbXBCVGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbXBCVGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 16:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXBCVGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 16:06:42 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:36687 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbXBCVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 16:06:41 -0500
Date: Sat, 03 Feb 2007 15:06:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Battery life on Lenovo X60s
In-reply-to: <fa.7bJzT2yHAw1twVZpYBqksfpGUy0@ifi.uio.no>
To: Casper Bruun <casperbruun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45C4F952.5090805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7bJzT2yHAw1twVZpYBqksfpGUy0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casper Bruun wrote:
> Hello
> 
> I and many others are having problems with battery life on the Lenovo
> X60s laptop.
> 
> There have been several threads concerning this on Nabble, thinkwiki
> and many other Linux sites, and the problem has always been the same:
> Linux draw significantly more power than XP on this particular laptop.
> 
> Everything known about the problem is summarized here:
> http://www.nabble.com/thinkpad-x60-Battery-Life--!-t1971716.html
> 
> I am posting here as a last resort, as I simply have no idea where
> else to ask. What could possibly be causing this?
> 
> As I am not very technical, I'm not sure what other information you
> need to look into this. Tell me if you need need config files, logs or
> anything.
> 
> Can someone please look into this? Any help would be greatly appreciated!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

The test results supposedly show that the CPU speed isn't being reduced 
when the kernel thinks it is. It looks like that test was using 
speedstep-centrino as the scaling driver, you may want to see if 
acpi-cpufreq works instead.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

