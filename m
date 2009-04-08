Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbZDHOZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbZDHOZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764371AbZDHOZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:25:18 -0400
Received: from rtr.ca ([76.10.145.34]:39200 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763155AbZDHOZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:25:16 -0400
Message-ID: <49DCB3C9.9040809@rtr.ca>
Date: Wed, 08 Apr 2009 10:25:13 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DB8B54.7050402@garzik.org> <49DB9422.5040702@rtr.ca> <20090407181033.GA2673@gentoox2.trippelsdorf.de> <49DBB071.6000105@rtr.ca> <20090408071404.GA2656@gentoox2.trippelsdorf.de>
In-Reply-To: <20090408071404.GA2656@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> ..
> The new firmware is out and looks promising:
> 
> ########## Begin SSD TRIM output ##########
> word21 bit10 = 1: support for the DATA SET MANAGEMENT is changeable.
> word169 bit0 = 1: device supports the Trim bit of DATA SET MANAGEMENT command.
>   word69 bit14 = 1: Trim function of the DATA SET MANAGEMENT command supports determinate behavior.
> ########## End SSD TRIM output ##########
> 
> This is the output from a modified hdparm, that checks the relevant bits. 
..

I'll release hdparm-9.14 shortly, with reporting for the TRIM feature in the -I output.

Cheers
