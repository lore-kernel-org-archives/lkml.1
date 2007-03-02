Return-Path: <linux-kernel-owner+w=401wt.eu-S1161304AbXCBHTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161304AbXCBHTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161296AbXCBHTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:19:55 -0500
Received: from mkedef1.rockwellautomation.com ([208.22.104.18]:20099 "EHLO
	ramilwsmtp01.ra.rockwell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161256AbXCBHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:19:54 -0500
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Victor <andrew@sanpeople.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.20-rc2] gpio_direction_output() needs an initial value
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5  CCH1 March 07, 2006
Message-ID: <OF3A5B99D3.1ADB09DE-ONC1257292.002838C5-C1257292.00285B34@ra.rockwell.com>
From: Milan Svoboda <msvoboda@ra.rockwell.com>
Date: Fri, 2 Mar 2007 08:20:47 +0100
X-MIMETrack: Serialize by Router on RAMilwSMTP01/Milwaukee/RA/Rockwell(Release 6.5.5FP2|October
 23, 2006) at 03/02/2007 01:20:56 AM,
	Serialize complete at 03/02/2007 01:20:56 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's been pointed out that output GPIOs should have an initial value, to
> avoid signal glitching ... among other things, it can be some time 
before
> a driver is ready.  This patch corrects that oversight, fixing
> 
>  - documentation
>  - platforms supporting the GPIO interface
>  - users of that call (just one for now, others are pending)
> 
> Note that most platforms are clear about the hardware letting the output
> value be set before the pin direction is changed, but the s3c241x docs
> are vague on that topic ... so those chips might not avoid the glitches.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Milan Svoboda <msvoboda@ra.rockwell.com>


