Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXELARf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXELARf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXELAR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:17:28 -0400
Received: from waste.org ([66.93.16.53]:55826 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbXELAR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:17:27 -0400
Date: Fri, 11 May 2007 19:17:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
Message-ID: <20070512001718.GY11166@waste.org>
References: <4644F726.1050806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4644F726.1050806@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 04:07:18PM -0700, Arjan van de Ven wrote:
> 
> What's eating the battery life of my laptop? Why isn't it many more 
> hours? Which software component causes the most power to be burned? 
> These are important questions without a good answer... until now.

I get:

No detailed statistics available; please enable the CONFIG_TIMER_STATS
kernel option

with:

$ zgrep STATS /proc/config.gz 
# CONFIG_TASKSTATS is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

-- 
Mathematics is the supreme nostalgia of our time.
