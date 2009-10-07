Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZJGVxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZJGVxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZJGVx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:53:29 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:50855
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414AbZJGVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:53:29 -0400
Date: Wed, 7 Oct 2009 23:52:48 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
Message-ID: <20091007215247.GA730@trillian.comsick.at>
References: <20091007175403.GA335@trillian.comsick.at>
 <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
 <ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com>
 <ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com>
 <20091007203121.GA432@trillian.comsick.at>
 <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
 <1254950602.2307.1.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254950602.2307.1.camel@yio.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009.10.07 23:23:22 , Kay Sievers wrote:
> Michael, you mentioned trying the udev git version. Any chance to check
> if that fixes it?
> 
> Thanks,
> Kay
> 
<snip>

I applied it to current git and gave it a quick spin with.

rmmod 8250_pnp;sleep 1;ls -la /dev/ttyS*;modprobe 8250_pnp;sleep 1;ls
-la /dev/ttyS*

I was not able to reproduce the problem even after 30 runs.
I will let it run some more just to be sure but so far it looks good.

Michael
