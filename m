Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYJXOBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYJXOBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYJXOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:01:28 -0400
Received: from swm.pp.se ([212.247.200.143]:42956 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYJXOB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:01:27 -0400
Date: Fri, 24 Oct 2008 16:01:25 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
In-Reply-To: <20081024130130.GA5816@denkbrett.schottelius.org>
Message-ID: <alpine.DEB.1.10.0810241546460.4948@uplift.swm.pp.se>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810240006.19857.rjw@sisk.pl> <1224817394.6623.12.camel@nigel-laptop> <200810240911.05193.rjw@sisk.pl> <20081024130130.GA5816@denkbrett.schottelius.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Nico -telmich- Schottelius wrote:

> Yes, I'm on amd64;

I'm on ubuntu 8.10-rc with all updates (so I'm on their 2.6.27-7 kernel) 
on Lenovo X200.

I can replicate the problems without X, I get an oops when it comes out of 
sleep (can't scroll up and nothing in the log).

If I shut down X, power down bluetooth (fn-F4) and rmmod btusb and 
bluetooth, I can successfully get the X200 to sleep (by executing the 
/etc/acpi/sleep.sh script) and come back up again properly.

If I have X enabled, power down bluetooth, /etc/ini.d/bluetooth stop and 
rmmod btusb/bluetooth, I still get the problem when coming out of sleep. I 
get a mouse pointer (unmovable), black background, and after 5-10 seconds 
I get hard power down (watchdog?).

I have tried to ctrl-alt-F1 to text console and make it go to sleep to see 
if this works in conjunction with X running, but it seems some X daemon is 
catching/hindering the fn-F4 and ./sleep.sh, so I haven't been able to try 
this.

Anything else I can test that might help?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
