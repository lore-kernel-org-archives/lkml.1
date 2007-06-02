Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXFBJWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXFBJWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 05:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXFBJWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 05:22:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58851 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXFBJWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 05:22:34 -0400
Date: Sat, 2 Jun 2007 11:22:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070602092232.GP7217@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <20070602010539.GA13512@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602010539.GA13512@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I feel, having a silent/transparent workaround is not a good idea. With that

If enough RAM is chopped off users will notice. They tend to complain
when they miss RAM.  I don't like panic very much because for many
users it will be a show stopper (even when they are not blessed
with "quiet" boots like some distributions do) 

The message in dmesg could be also emphasized a bit with a little
ASCII art (but no <blink> tag in there) 

The problem I'm more worried about is if the system will be really
stable --- could it be that the memory controller is still
misconfigured and cause other stability issues? (we've had such
cases in the past). Also I'm not sure we can handle the case of 
the MTRR wrong not at the end of memory but at the hole sanely.

-Andi
