Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbXGDIzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbXGDIzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbXGDIyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:54:55 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58644 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564AbXGDIyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:54:54 -0400
X-Greylist: delayed 1896 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 04:54:53 EDT
Date: Wed, 4 Jul 2007 11:23:15 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6: NMI oops and long pauses during boot
In-Reply-To: <Pine.SOC.4.64.0706260833480.19044@math>
Message-ID: <Pine.SOC.4.64.0707041120270.18295@math>
References: <Pine.SOC.4.64.0706260833480.19044@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> First boot hung with oops/bug dump. I did not have a camera ready but it 
> was an oops-like dump that included die_nmi or something similar about 
> NMI.
> 
> Second boot booted fine until INIT had started and then came a long 
> pause (tens of seconds). When I pressed Ctrl-Alt-Del it became alive and 
> continued the bootup until it noticed the Ctrl-Alt-Del.
> 
> Third boot was similar but the pause appeared before INIT: line and 
> after mounting root and writeprotecting kernel text and readonly 
> data. Ctrl-Alt-Del revived it again.

Tried it again with 2.6.22-rc7 + todays git. Still the same, this time 
it waited after loading PC speaker driver and before announcing tsc 
clocksource as not good enough, and pressing Enter made it continue.

Unfortunately I will be away from this computer for about 2 weeks so 
I can't test anything with it. It's still a regression but not worth 
holding up 2.6.22 for me if no one other sees it.

-- 
Meelis Roos <mroos@linux.ee>
