Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbXJNVZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbXJNVZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759682AbXJNVZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:25:07 -0400
Received: from a.mail.sonic.net ([64.142.16.245]:38460 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbXJNVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:25:05 -0400
X-Greylist: delayed 1492 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 17:25:05 EDT
Message-ID: <4712835C.5050400@sonic.net>
Date: Sun, 14 Oct 2007 14:00:12 -0700
From: Scott Petler <scottp@sonic.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: "Doug Whitesell (LKML)" <dcw-kernel@screamingdolphin.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel panic
References: <47114B46.10403@sonic.net> <1192393469.7573.8.camel@heimdal.trondhjem.org> <47127FA8.6040506@sonic.net> <1B7E8ED9-7DA9-41CA-BDF9-219E71AAA905@screamingdolphin.net>
In-Reply-To: <1B7E8ED9-7DA9-41CA-BDF9-219E71AAA905@screamingdolphin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

I thought that might do it, it does seem to work.  I edited the driver 
line in my xorg.conf
from nvidia to nv and then,
<alt><ctrl> F1
login as root
/etc/init.d/gdm stop
/etc/init.d/gdm start

It came back up with the same flashing crap on the second monitor, so I 
did it again with
the 2nd monitor turned off altogether, and I'll see how long it will run 
on the single monitor
without the nvidia driver without crashing (maybe forever...).

Thanks,
Scott

Doug Whitesell (LKML) wrote:
> On Oct 14, 2007, at 1:44 PM, Scott Petler wrote:
>
>> Trond,
>>
>> I'm not exactly sure how to go back to not using the nvidia driver 
>> and select the xorg one.  I do know that I wasn't able to use both 
>> monitors with the xorg driver, but I'm willing to try that to isolate 
>> the problem.
>
> If memory serves, you change your xorg.conf's "Device" section's 
> "Driver" entry to read:
> "nv"
> instead of
> "nvidia",
>
> although I would consult the xorg documentation/your distribution's 
> documentation (and back up your working xorg.conf) for specific 
> details. (Your boot sequence may also automatically load the nvidia 
> module, again, consult your distribution's documentation for details.)
>
> Cheers/hope this helps,
> dcw
>
>
