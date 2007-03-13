Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbXCMCjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbXCMCjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXCMCjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:39:32 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:55180 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXCMCjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:39:32 -0400
Date: Mon, 12 Mar 2007 22:39:28 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Stracing Amanda (was: RSDL for 2.6.21-rc3- 0.29)
In-reply-to: <874poqj5db.fsf_-_@suzuka.mcnaught.org>
To: linux-kernel@vger.kernel.org
Cc: Douglas McNaught <doug@mcnaught.org>, Patrick Mau <mau@oscar.ping.de>
Message-id: <200703122239.29256.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <20070312195436.GA15319@oscar.prima.de> <874poqj5db.fsf_-_@suzuka.mcnaught.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Douglas McNaught wrote:
>Patrick Mau <mau@oscar.ping.de> writes:
>> Why not temporarly replace "/bin/tar" with a shell script that does:
>>
>> #!/bin/sh
>> exec strace -f -o output /bin/real.tar $@
>
>You beat me to it.  :) I've done that before; it's a great suggestion.
>
>Except that if you expect 'tar' to be invoked multiple times in a run,
>you should probably use 'output.$$' for the output filename so things
>don't get clobbered.
>
>-Doug

In my case, Doug, it will get invoked 64 times, amanda does a dummy run to 
get an estimate, calculates what to do based on that output which is 32 
runs, 1 per disklist entry and I have 32, and then reruns tar with the 
appropriate level options against each individual disklist entry.

But I'm puzzled a bit, what does the double $$ do?, or it buried someplace 
in the bash manpage?  Its not something I've stumbled over yet.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
rugged, adj.:
	Too heavy to lift.
