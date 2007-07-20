Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXGTCmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXGTCmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXGTCmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:42:24 -0400
Received: from mail.tmr.com ([64.65.253.246]:37277 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXGTCmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:42:23 -0400
Message-ID: <46A0210E.6010207@tmr.com>
Date: Thu, 19 Jul 2007 22:42:22 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: [RFC] what should 'uptime' be on suspend?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just found a machine which will resume after suspend to memory, using 
the mainline kernel (no suspend2 patch).

On resume I was looking at the uptime output, and it was about six 
minutes, FAR longer than the time since resume. So the topic for 
discussion is, should the uptime be
 - time sine the original boot
 - total uptime since first boot, not counting the time suspended
 - time since resume
 - some other time around six minutes

Any of the first three could be useful and "right" for some casesm thus 
discussion invited.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

