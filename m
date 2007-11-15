Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXKOMqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXKOMqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbXKOMqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:46:15 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43012 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293AbXKOMqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:46:13 -0500
Date: Thu, 15 Nov 2007 07:42:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jean Delvare <khali@linux-fr.org>
cc: Julia Lawall <julia@diku.dk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/i2c: Drop redundant includes of 
 moduleparam.h
In-Reply-To: <20071115131915.0eb34c98@hyperion.delvare>
Message-ID: <alpine.LFD.0.9999.0711150739490.9736@localhost.localdomain>
References: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk> <alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain> <Pine.LNX.4.64.0711140707120.25487@ask.diku.dk> <alpine.LFD.0.9999.0711140416160.4673@localhost.localdomain>
 <20071115131915.0eb34c98@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Jean Delvare wrote:

... snip ...

> I share Robert's point of view here. Relying on header files
> including each other is usually not a good idea, as build then
> breaks when the headers are cleaned up or reorganized.

... more snip ...

> If there's a fundamental reason why module.h has to include
> moduleparam.h, then both headers should be merged in a single file.
> If not, then both header files should be clearly split and drivers
> should include each of them as needed. Either way, header files must
> be fixed first, and drivers adjusted in consequence. So, I'm not
> taking this patch, sorry.

keeping this short and sweet, i updated my wiki page on this topic:

http://www.crashcourse.ca/wiki/index.php/Module.h_and_moduleparam.h

i think the fundamental question here is whether this is even
cleanable without massive disruption.

rday

--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
