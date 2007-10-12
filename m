Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXJLNaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXJLNaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJLNar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:30:47 -0400
Received: from rtr.ca ([76.10.145.34]:3899 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXJLNar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:30:47 -0400
Message-ID: <470F7705.3@rtr.ca>
Date: Fri, 12 Oct 2007 09:30:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: crash@treysoft.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: hdparm standby timeout not working for WD raptors?
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>	 <470E7B90.5060203@rtr.ca> <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
In-Reply-To: <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Weber wrote:
>
> # hdparm -S1 -C /dev/sda; sleep 6; hdparm -C /dev/sda
> 
> /dev/sda:
>  setting standby to 1 (5 seconds)
>  drive state is:  active/idle
> 
> /dev/sda:
>  drive state is:  active/idle

That's interesting.

So, either something is regularly accessing/polling the drive,
or it just doesn't work with the standby timer.

Are there any interesting kernel messages being generated
during execution of those commands?

-ml
