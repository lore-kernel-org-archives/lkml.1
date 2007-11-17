Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXKQIpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXKQIpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXKQIpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:45:38 -0500
Received: from dns2.fullrate.dk ([89.150.129.10]:51099 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXKQIph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:45:37 -0500
Message-ID: <473F281B.60408@minimum.se>
Date: Sat, 17 Nov 2007 09:42:51 -0800
From: Martin Olsson <mnemo@minimum.se>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dane Mutters <dmutters@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
References: <473E815F.30900@minimum.se>	 <20071116213137.6efe3f9e@the-village.bc.nu>  <473E9290.3040006@minimum.se>	 <1195281942.15929.5.camel@Orchestrator> <1195285481.3059.12.camel@twins>
In-Reply-To: <1195285481.3059.12.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(taking this reply offline, so this is mostly intended for Alan)

Peter Zijlstra wrote:
> 
> If you don't know which limits to set and need a package for them, your
> job title should not be system administrator.
> 

In theory I agree with you Peter but in practice a lot of low-skill 
people have to install and administer servers. I think the pragmatic and 
realistic approach would be to accept that many admins are not perfect, 
far from it.

Also, this bug involves many aspects and it's possible to argue what 
exactly is the bug. Even if we don't change any default values, we can 
still change the kernel so that it survives a fork bomb. After all, the 
Vista kernel does survive a fork bomb although the system as a whole 
gets unusable.

### On Ubuntu I currently see:
1. Launch fork bomb
2. System gets to a complete freeze (I can't move mouse and not a single 
pixel is updated on the screen).

### On Vista I currently see:
1. Launch fork bomb
2. System gets very slow to the point where the system is unusable (but 
I can always mouse around the mouse freely with no sluggishness and the 
screen updates continue to make progress even though it takes 1-3 
seconds between each update). I can still open and close the start menu 
if I got the patience to wait >45 seconds for it each time.

I don't think that setting a max process count by default is a 
good/viable solution. But the kernel could still be changed so that it 
doesn't hose itself completely.



		Martin
