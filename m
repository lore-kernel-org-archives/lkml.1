Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYEALiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYEALiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYEALiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:38:14 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:51456 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbYEALiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:38:14 -0400
Date: Thu, 1 May 2008 13:38:02 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: A system for rebootless kernel security updates
Message-ID: <20080501113802.GC28005@nibiru.local>
Reply-To: weigelt@metux.de
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <87r6cvgyi1.fsf@basil.nowhere.org> <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu> <4815A721.1040101@firstfloor.org> <alpine.DEB.1.10.0804281907150.28653@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0804281907150.28653@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ,
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42,
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida,
X-Killer: 23, endloesung, Weltuntergang,
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Arnold <jbarnold@MIT.EDU> wrote:

Hi,

> I'm willing to undertake the project of bringing the code up to kernel 
> coding standards so that it can eventually be considered for mainline. 
> I'll plan on undertaking this project if I don't receive feedback that I 
> shouldn't do so.

Great think :)
I'd actually like to see it mainline tree (I prefer vanilla kernel
instead of distro specific). 

> If people have concerns about the high-level design of the system, it 
> would be useful for me to know that information sooner rather than later.

I didn't have the time for an deeper study yet, but as you already
mentioned, there're lots of limitations which can make it harmful:
as soon as interfaces chance, you're in *big* trouble. There should
be a way for finding them (automatically). Maybe extract the 
interface signatures (including structs!) so some appropriate place
next to the kernel, so they can be checked before (re)loading the
module.

Ah, of course you can't change code that's not an dynamic module :(


Even this goes OT now - I'd really prefer more things in userland,
eg. network- or synthetic filesystems, crypt stuff, etc - so 
there would be less to update within the kernel ;-o

cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
