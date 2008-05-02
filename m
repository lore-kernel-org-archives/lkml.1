Return-Path: <linux-kernel-owner+w=401wt.eu-S934703AbYEBMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703AbYEBMR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764173AbYEBMRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:17:20 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:48009 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636AbYEBMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:17:20 -0400
Date: Fri, 2 May 2008 14:16:42 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: API for changing UIDs of other processes
Message-ID: <20080502121641.GB7997@nibiru.local>
Reply-To: weigelt@metux.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,


I'd like to build some authentication daemon which alters the
privileges of another process (like factotum does on plan9).
But I couldn't find any interface for that (setuid() and friends
only operate on the current process). So I'm now going to create
my own interface.

As a little learning example I just added a few files to the
per-pid dirs: uid, euid, suid, fsuid. This was trivial :)

Now I'd like to add an write capability to these files: 
simply writing another number changes the (|s|fs)uid.

But this doesnt seem that trivial. Perhaps someone could give
me some advice ?


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
