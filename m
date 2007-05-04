Return-Path: <linux-kernel-owner+w=401wt.eu-S1031701AbXEDVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031701AbXEDVFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031707AbXEDVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:05:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:40878 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031701AbXEDVFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:05:40 -0400
Date: Fri, 4 May 2007 23:03:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463B9380.5090503@interia.pl>
Message-ID: <Pine.LNX.4.61.0705042303030.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <463B687D.1020600@interia.pl> <Pine.LNX.4.61.0705042042270.18504@yvahk01.tjqt.qr>
 <463B9380.5090503@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 22:11, Rafał Bilski wrote:
>> 
>>> It has big latency and requires so much preparation that it isn't worth 
>>> if You don't need to save power or cool down CPU. 
>> 
>> I found frequency switching on my VIA to be fast enough.
>
>Timer frequency equal to 1000Hz? 

The regular irq0 timer ticks at 250. What I meant is that I do not have
to wait more than 0.5 seconds for cpufreq-set to finish.


Jan
-- 
