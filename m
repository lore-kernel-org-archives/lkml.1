Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZL3Lgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZL3Lgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZL3Lgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:36:45 -0500
Received: from swm.pp.se ([212.247.200.143]:60849 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZL3Lgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:36:45 -0500
Date: Wed, 30 Dec 2009 12:36:43 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Jens Axboe <jens.axboe@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
In-Reply-To: <20091230111745.GC4489@kernel.dk>
Message-ID: <alpine.DEB.1.10.0912301232570.27231@uplift.swm.pp.se>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.Zg.inhOLB@chimera> <20091230111745.GC4489@kernel.dk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009, Jens Axboe wrote:

> Works fine for me on an x200s. The only issue I seem to have is that 
> sometimes it suspends immediately upon resume again, presumably the lid 
> close event is re-triggered (or something to that extent). Apart from 
> that, 2.6.32 and current -git works fine for me.

There is an issue in 2.6.31 where it will panic (at least that's what I 
think it does, please see more details in 
<https://bugs.launchpad.net/bugs/473876>) when you have it plugged in, 
suspend, un-plug the power cable, and then resume it.

According to <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/467877> 
it has something to do with "event_when_closed_battery", I haven't tested 
it yet though, neither with 2.6.31 nor 2.6.32. Could be beneficial for 
more people to test though.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
