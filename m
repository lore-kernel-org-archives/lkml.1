Return-Path: <linux-kernel-owner+w=401wt.eu-S935103AbXGLQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbXGLQfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbXGLQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:35:07 -0400
Received: from rtr.ca ([64.26.128.89]:3657 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759835AbXGLQfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:35:05 -0400
Message-ID: <46965837.8030907@rtr.ca>
Date: Thu, 12 Jul 2007 12:35:03 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707121446.14170.rjw@sisk.pl> <469631FA.2070405@rtr.ca> <200707121735.40077.rjw@sisk.pl> <469650DE.4000901@rtr.ca>
In-Reply-To: <469650DE.4000901@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Rafael J. Wysocki wrote:
>..
>> How much RAM is there in your machine?
> 
> 2GB, but It doesn't need to dump that much for good performance.
> Hibernate here consists of:
> 
>   echo "$(( 256 * 1024 * 1024 ))" > /sys/power/image_size
>   echo -n disk > /sys/power/state
> 
> Plus a couple of fiddly commands to deal with the ATI binary X server.

Whoops.. wrong half of the script.
For TuxOnIce in 10 seconds, it does this:

  echo 288 > /sys/power/suspend2/image_size_limit
  echo > /sys/power/suspend2/do_suspend
