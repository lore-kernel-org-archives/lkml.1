Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYFHJUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYFHJUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYFHJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:20:04 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:55147 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYFHJUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oc5fHFScXtcSvohDwKCycUnlXKsnffiga3vNT2meiWrLjXSwHRTepBYlJKG+XCzCXx
         YAWu82pylQVo/SoGa3D77tlg3gkCuchvDcF10Wmb5GHrK41nmhASWIA/pvgnQvbQPcFf
         9MEtXIqykm9ijjjGf9rjDEZDSGhkwS8S3a4dE=
Date: Sun, 8 Jun 2008 13:19:54 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC][PATCH 0/3] Clocklib: generic clocks management framework
Message-ID: <20080608091954.GA11200@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is second attempt to introduce clocks management framework based on
kobjects. This attempt goes a bit further. I've removed the global
spinlock. All add/remove operations are guarded via built into clocks kset
spinlock. And all per-clock operations are guided by built-in atomic
counter variable. I can split it into counter and per-clock spinlock,
but I think it will be a waste of space.

Also as suggested by Andrew Morton, I've split the set_mode operation
back to enable/disable.

-- 
With best wishes
Dmitry

