Return-Path: <linux-kernel-owner+w=401wt.eu-S2992995AbXDRXg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992995AbXDRXg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992989AbXDRXg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:36:28 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2856 "EHLO
	mail.rtr.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992986AbXDRXg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:36:27 -0400
Message-ID: <4626AB77.20709@rtr.ca>
Date: Wed, 18 Apr 2007 19:36:23 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>,
       Stephen.Clark@seclark.us
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com>	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>	 <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com> <46253F14.4020304@rtr.ca> <462540CD.9080406@redhat.com> <46254416.6090202@rtr.ca> <4625AF20.7050904@gmail.com>
In-Reply-To: <4625AF20.7050904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
> 2. kernel shutdown starts
> 3. libata shutdown issues SYNCHRONIZE_CACHE
> 4. power goes off

Okay, after some experimentatino, it's the STANDBY_NOW that
is causing the Power-Off_Retract_Count to increment on my machine.

Tell me again why we think we need to issue that command ?

Thanks.
