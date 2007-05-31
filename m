Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbXEaLU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbXEaLU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXEaLUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:20:21 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39510 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759376AbXEaLUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:20:20 -0400
Message-ID: <465EAF90.3030803@drzeus.cx>
Date: Thu, 31 May 2007 13:20:48 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
References: <4655834F.3050301@drzeus.cx>	<20070524170654.5d674474.akpm@linux-foundation.org>	<4656602A.3010000@drzeus.cx> <20070524211737.daa3c99c.akpm@linux-foundation.org> <465666AE.5020600@drzeus.cx>
In-Reply-To: <465666AE.5020600@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What was the verdict here? Were you satisfied with this or do you need a change?

Pierre Ossman wrote:
> Andrew Morton wrote:
>> Whatever.  I think you can work it out ;)   
>>
>>   
> 
> Bare with me, I just woke up ;)
> 
>> while (driver_probe_done() || (ROOT_DEV = name_to_dev_t(...)) == 0)
>>
>> perhaps?
>>
>> The loop-which-sleeps within a loop-which-sleeps seems poorly thought out?
>>   
> 
> I'd say a matter of taste. I'm not a big fan och cramming things into
> the while() clause.
> 
> The idea with the double loops was to keep this thread asleep when we
> could detect meaningful work elsewhere in the kernel. You could just
> remove the inner-most loop if it offends you. :)
> 

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
