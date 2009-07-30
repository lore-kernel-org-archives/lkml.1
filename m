Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZG3VKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZG3VKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZG3VKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:10:54 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34938 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZG3VKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:10:54 -0400
X-Greylist: delayed 1190 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 17:10:54 EDT
Date: Fri, 31 Jul 2009 00:10:50 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Thinkpad X20 docking troubles - irq routing, USB strangeness
In-Reply-To: <Pine.SOC.4.64.0907302339550.23777@math.ut.ee>
Message-ID: <Pine.SOC.4.64.0907310007040.24315@math.ut.ee>
References: <Pine.SOC.4.64.0907302339550.23777@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first is irq-related. As soon as yenta driver discovers the 
> additional ports, screaming irq happens and this shared irq is disabled.
> This documented in the dmesg below. This is my main problem, others may 
> be secondary to it (at least the usb one).

One more data point: the behaviour seems to be consistent at least since 
2.6.27 (the oldest sequential kernel I have around). I also have 2.6.21 
laying around, this kernel did not support docking at all.

Another data point: starting the system without dock and later docking, 
PCI devices in dock are not found and no yenta irq problems occur.

When docking, USB 4-port hub is found and works.

-- 
Meelis Roos (mroos@linux.ee)
