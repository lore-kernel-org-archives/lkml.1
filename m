Return-Path: <linux-kernel-owner+w=401wt.eu-S935569AbXFFTVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbXFFTVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935320AbXFFTTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:19:07 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53294 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411AbXFFTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:19:01 -0400
Message-ID: <466708D8.90208@student.ltu.se>
Date: Wed, 06 Jun 2007 21:19:52 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: generic bool and sparse errors?
References: <4666FD0A.4060609@intel.com>
In-Reply-To: <4666FD0A.4060609@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
>
> I'm experimenting with using the generic bool type and using sparse I 
> get tons of these messages:
>
> warning: incorrect type in argument 4 (different signedness)
>     expected bool [unsigned] [usertype] *[unsigned] success
>     got bool *<noident>
>
> I'm not really worried about this, I assume that sparse hasn't caught 
> up with what bool really means, but perhaps this can be looked into by 
> someone who knows sparse well. The warnings don't really add up and 
> with more people switching to use the generic bool this may beceome 
> unwanted.
Actually, I am "assigned" to that. :)
Just out of curiousity, where do you see those messages? In the log for 
allyesconfig on i386 I only found ntfs/super.c with similar output.
>
> alternatively we might need to reconsider the `typedef _Bool bool;` 
> declaration and force it to be unsigned. I'm not sure what to think of 
> that.
I do not see how that would make any sense.

Richard Knutsson

