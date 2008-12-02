Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYLBS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYLBS4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYLBSz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:55:58 -0500
Received: from rtr.ca ([76.10.145.34]:46402 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYLBSz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:55:57 -0500
Message-ID: <49358502.9090000@rtr.ca>
Date: Tue, 02 Dec 2008 13:57:06 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Len Brown <lenb@kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [rtc-linux] Re: PATCH: /proc/acpi/alarm: handle day-of-month
 wraparound on readback
References: <200806222042.13929.david-b@pacbell.net>	<4934176F.6080900@rtr.ca>	<alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>	<49346212.3050102@rtr.ca> <20081201233210.598f2dcf@i1501.lan.towertech.it>
In-Reply-To: <20081201233210.598f2dcf@i1501.lan.towertech.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Mon, 01 Dec 2008 17:15:46 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Yeah.. bit of a nuisance that.
>> I regularly apply this patch to my own kernels:
> 
>  While it will certainly work, maybe it's time to switch
>  to /sys/class/rtc/rtcX/wakealarm . 
..

Perhaps, but doing so would still leave the but in /proc/acpi/alarm,
so we need to fix it regardless.

Cheers
