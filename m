Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYH0RNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYH0RNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYH0RNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:13:33 -0400
Received: from relay5.mail.uk.clara.net ([80.168.70.185]:38967 "EHLO
	relay5.mail.uk.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYH0RNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:13:33 -0400
X-Greylist: delayed 6396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 13:13:32 EDT
Message-ID: <48B58B38.30303@onelan.com>
Date: Wed, 27 Aug 2008 18:13:28 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joe Korty <joe.korty@ccur.com>
CC: Mark Brown <broonie@sirena.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression, v2
References: <20080827151613.GA10325@tsunami.ccur.com> <20080827161621.GF10834@sirena.org.uk> <20080827170424.GA17217@tsunami.ccur.com>
In-Reply-To: <20080827170424.GA17217@tsunami.ccur.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Clara-Relay: Message sent using Claranet Relay Service using auth code: simon.farnsworth@onelan.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty wrote:
> On Wed, Aug 27, 2008 at 12:16:30PM -0400, Mark Brown wrote:
>> It'd be nicer if this were optional - syslog typically only logs at
>> second resolution and not all systems are going to have logfiles.
> 
> 
> Optionally suppress printk timestamping after system boot.
> 
JOOI, what's wrong with having your init scripts contain a line like:
echo 0 > /sys/module/printk/parameters/time
?

This has the advantage that you can avoid turning the kernel's
timestamps off until you know that syslog is running and timestamp
events that it's receiving.
-- 
Simon Farnsworth

