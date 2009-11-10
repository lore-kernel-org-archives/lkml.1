Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZKJJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZKJJ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZKJJ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:28:33 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:46487 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbZKJJ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:28:32 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 04:28:31 EST
Date: Tue, 10 Nov 2009 10:20:13 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Changing another process' UID
Message-ID: <20091110092013.GA575@nibiru.local>
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


for properly porting Plan9's factotum to Linux, I need some way
to change an running process's uid/gid.

Plan9 has special devices /dev/caphash and /dev/capuse for that.

Some time ago I chose to hack up a different, a bit more generic 
way: adding special new uid / gid files to the /proc entries,
so another (root) process can change the uid of an already
running process.

I suppose there's a better way via Linux's caps api, isnt it ?


thx
--
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
