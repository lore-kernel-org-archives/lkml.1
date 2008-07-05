Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYGEQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYGEQbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 12:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGEQbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 12:31:05 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:50885 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbYGEQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 12:31:04 -0400
Date: Sat, 5 Jul 2008 18:29:02 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: block devices in userland
Message-ID: <20080705162902.GA26789@nibiru.local>
Reply-To: weigelt@metux.de
References: <342518340@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342518340@web.de>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* devzero@web.de <devzero@web.de> wrote:
> >is there an API for writing block device drivers in userland ?
> 
> i don`t know if there is some in vanilla, but maybe dm-userspace is worth taking a look at ?
> see http://wiki.xensource.com/xenwiki/DmUserspace

hmm, doesn't seem to be what I'm looking for - it just leaves the 
mapping of virtual to physical blocks to userland. 

What I need is passing the whole read/write requests to some userland
deamon - these blocks won't come from any (in-kernel) block device,
but an totally different kind of storage (eg. venti).


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
