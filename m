Return-Path: <linux-kernel-owner+w=401wt.eu-S1763817AbXF0XPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763817AbXF0XPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbXF0XPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:15:35 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:42616 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbXF0XPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:15:34 -0400
Message-ID: <4682EF80.9050504@hp.com>
Date: Wed, 27 Jun 2007 19:15:12 -0400
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: announcing collectl - a new performance monitoring tool
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick plug for a utility I wrote a number of years ago and have 
recently open sourced.  It's been around as an internal tool for about 4 
years and so has been pretty well shaken out.  There's a pretty good 
description and some example output at 
http://collectl.sourceforge.net/index.html and you can download it at 
http://sourceforge.net/projects/collectl.

What I believe makes this tool different from the already large number 
of 'stat' and other performance monitoring tools is its goal is to be a 
one-stop place for everything and it can collect data on most system 
counters as well as non-standard things such as lustre, infiniband, 
quadrics to name a few.  The data of your choice (the default is cpu, 
disk and network) is displayed horizontally for easy reading, one line 
per sample, which is only limited by how wide you want to make your 
window.  You can display summaries, such as aggregate cpu, disk, 
network, slabs or even lustre traffic OR you can report detail level 
data such as individual NIC traffic, disks, cpus and in the case of 
lustre individual OSTs!  How about only reporting those slabs that 
changed in size between polling intervals?  Or how about seeing nfsstat 
output on a single line!  You can even choose fractional polling 
intervals.  Did you know network stats are only updated once a second?  
Run collectl with a 0.1 second polling interval and see for yourself!

Another biggie is collectl can generate data in 'space separated' format 
so that you can easily plot it using gnuplot, openoffice or if you're of 
that persuasion you can even use excel.

And the best news of all, collectl is very light-weight, using about 
0.03% of the cpu on my amd/xeon boxes.  Naturally your mileage may vary 
depending how many processes or devices may be on your system, but we 
run it continuously on most of our systems and don't even know it's there.

There's far too much to say about it so I won't try.  Install it, read 
the FAQ and check out the 'extended help' and all the man pages - yes, 
there are multiple ones.

Feel free to download it and let me know what you think.  Just be aware 
I'm getting ready to release a new version so if you like what you see 
check back in a day or so and get a newer version.

-mark


