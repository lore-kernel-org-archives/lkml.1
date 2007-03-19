Return-Path: <linux-kernel-owner+w=401wt.eu-S965813AbXCSIoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965813AbXCSIoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965827AbXCSIoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:44:54 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:40019 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965813AbXCSIoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:44:54 -0400
Message-ID: <45FE4D58.2000303@free.fr>
Date: Mon, 19 Mar 2007 09:44:08 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org,
       tglx@timesys.com, linux.kernel@free.fr
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.3
References: <45F82CF3.3050904@free.fr>
In-Reply-To: <45F82CF3.3050904@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John wrote:

> I've tweaked patch-2.6.20-rt8 so that it applies to 2.6.20.3
> 
> The unified diff is attached to this message.
> 
> I'd be happy to hear comments on what I've done wrong!

Would anybody care to comment on the patch? :-)

I made 4 simple edits.

linux/Makefile
   trivial fix for EXTRAVERSION

linux/drivers/kvm/kvm_main.c
   remove a patch that has already been applied (?) to 2.6.20.3

linux/kernel/time/clocksource.c
   add one line, remove another, to make patch happy

linux/net/xfrm/xfrm_user.c
   remove a patch that has already been applied (?) to 2.6.20.3

Regards.
