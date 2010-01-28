Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0A1Dcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0A1Dcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 22:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165Ab0A1Dcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 22:32:48 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:38868 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108Ab0A1Dcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 22:32:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscAAIKUYEtLd/sX/2dsb2JhbAAIgzHEd490gSp6gT1YBA
X-IronPort-AV: E=Sophos;i="4.49,357,1262581200"; 
   d="scan'208";a="54722813"
Message-ID: <4B61055C.8040604@teksavvy.com>
Date: Wed, 27 Jan 2010 22:32:44 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <20100127120820.GB25750@csn.ul.ie> <4B60C0A7.7090501@teksavvy.com> <alpine.DEB.2.00.1001271701170.17513@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001271701170.17513@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Wed, 27 Jan 2010, Mark Lord wrote:
>> It's rock solid again with 2.6.31.12 on it now.
>>
> 
> Is there something specific about the workload that makes it easily 
> reproducible?  Are you saying that 2.6.31.12 is "rock solid" because it 
> has survived a certain workload that caused these page allocation failures 
> with 2.6.32.5, or simply because it has a longer uptime and hasn't shown 
> a problem?  It would be very helpful to describe the load so that we can 
> attempt to reproduce it locally without a sacrifice to your server.
..

Good questions, and I do "feel for you" here.  :)

That machine has a light workload.  Web server, email server,
dhcp for the small local network, name server, etc.

It sits at one end of a 6mb/1.5mb DSL connection, hardly busy at all.

But the logfile posted shows many of those "allocation failures"
within the first (only)36 hours of running 2.6.32.5:

  mirrordir (doing a backup to a USB drive)
  apcupsd  (UPS monitoring; hardly an intensive activity)
  apache2  (the web server receives rather light use, and no fancy php or anything)
  apache2  (again!)
  apache2  (and again)
  apache2  (another)
  apache2  (yet again)
  ...
  apache2  (and again again)
  vim      (hey, can't a guy edit his driver sources ??)
  cc1      (or compile them?)

So, not much happening, really.
It's a slow machine, a 600Mhz C7 ("VIA Samuel 2"), with only 512MB of RAM.

We've got 2.6.32.5 running on several other machines here with nary a glitch,
but all of those have 2-4GB of RAM.

Cheers
