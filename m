Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYALWYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYALWYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYALWYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:24:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59210 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbYALWYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:24:16 -0500
Date: Sun, 13 Jan 2008 00:23:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew.Morton@hera.kernel.org
Subject: Re: Top 10 kernel oopses for the week ending January 12th, 2008
Message-ID: <20080112222322.GE17276@does.not.exist>
References: <47890B65.80804@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47890B65.80804@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 10:48:05AM -0800, Arjan van de Ven wrote:
> The http://www.kerneloops.org website collects kernel oops and
> warning reports from various mailing lists and bugzillas as well as
> with a client users can install to auto-submit oopses.
> Below is a top 10 list of the oopses collected in the last 7 days.
> (Reports prior to 2.6.23 have been omitted in collecting the top 10)
>
> This week, a total of 136 oopses and warnings have been reported,
> compared to 46 reports in the previous 7 days.
>
> kerneloops.org news:
> 	* Based on feedback from last weeks report, the website now tries
> 	  to also present a disassembled Code: line
> 	* the kerneloops collection client is now part of Fedora (rawhide)
> 	  (yum install kerneloops)
> 	* the kerneloops collection client is now included in Debian testing
> 	  (apt-get install kerneloops)
> 	* gentoo has received an updated version of the client
>
>
> Rank 1: implement (hid code)
> 	WARN_ON at drivers/hid/hid-core.c:784
> 	Reported 23 times (39 total reports)
> 	This appears to be the kernel doing a WARN_ON based on unexpected ioctl() arguments
> 	More info: http://www.kerneloops.org/search.php?search=implement
>...

The only complete bug reports seems to be from one user who loaded a 
module whose distribution might be considered a criminal act in some 
countries.

All the other reports only contain the plain trace. Is there any way to 
get more information whether the former is a pattern or not, and to
get this information somehow displayed on the webpage?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

