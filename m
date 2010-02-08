Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0BHGDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:03:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43954 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0BHGDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:03:19 -0500
Date: Mon, 08 Feb 2010 15:03:17 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH] regulator: Add enable_time on probe of WM8994
In-reply-to: <20100207235650.GA14408@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Message-id: <4B6FA925.7070808@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <4B6E0C36.3090608@samsung.com>
 <20100207235650.GA14408@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 08 Feb 2010 06:03:17.0690 (UTC)
 FILETIME=[689009A0:01CAA884]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2010 8:56 AM, Mark Brown wrote:
> On Sun, Feb 07, 2010 at 09:41:26AM +0900, Joonyoung Shim wrote:
>> WM8994 regulator needs some delay to enable when it is probed too.
> 
> What is the problem that's fixed by this change?
> 
> The only case I can think of where it would help is if the regulator
> constraints are used to enable the regulators and run them at a
> non-default voltage.  (which is not a recommended configuration since

You're right. I misunderstanded something. The default voltage already 
is setted at the WM8994 ldo registers, but i made a mistake that set it
again on probe via the regulator constraints.

Thanks.
