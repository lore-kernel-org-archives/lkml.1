Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYEENVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYEENVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYEENVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:21:16 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:40226 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbYEENVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:21:15 -0400
Date: Mon, 5 May 2008 15:20:30 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: API for changing UIDs of other processes
Message-ID: <20080505132030.GE32019@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080502121641.GB7997@nibiru.local> <alpine.LNX.1.10.0805021602160.6463@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805021602160.6463@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt <jengelh@medozas.de> wrote:

> >Now I'd like to add an write capability to these files: 
> >simply writing another number changes the (|s|fs)uid.
> >
> >But this doesnt seem that trivial. Perhaps someone could give
> >me some advice ?
> 
> Not really hard, is it? Just look at something like oom_adj

Well, it's not that trivial than just an ro string file.
But not that hard as I first suspected :)

I've introduced a few new helpers for rw integers, which works
quite similar to the ro string stuff, but with anouther handler type.

I'll post a patch in the new testers list.

The next step is actually changing the uid. Can I just write 
new values to the uid field(s) in the task struct or is there
something tricky about that ?


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
