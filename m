Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYEEMlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYEEMlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYEEMlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:41:12 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:56954 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbYEEMlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:41:11 -0400
Date: Mon, 5 May 2008 14:40:41 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: VFS + path walktrough
Message-ID: <20080505124041.GB32019@nibiru.local>
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

could anyone please enlighten me, what exactly happens when 
some app opens an file with some longer pathname ?

Lets say we open /a/b/c/d and /a is mounted w/ some network 
filesystem (eg. 9P). Who exactly does the walktrough from b to d ?
The individual filesystem or VFS ?

The point is: the 9P protocol can work with whole pathnames, so
the client doesn't have to do the walkthrough manually - this
can heavily reduce traffic and latency. I'd like the 9P fs driver
to directly use this, if VFS can send the whole pathname at once.


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
