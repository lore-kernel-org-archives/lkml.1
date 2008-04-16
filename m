Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYDPBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYDPBps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYDPBp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:45:27 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:39116 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbYDPBp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:45:26 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 21:45:26 EDT
Date: Wed, 16 Apr 2008 03:30:34 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Automatic page sharing/consolidation
Message-ID: <20080416013033.GA3057@nibiru.local>
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

I'm using dozens of VE's / jails to separate applications
(even complete webapps w/ their own httpd) for easier maintenance
and better security. But this tends to consume a lot of memory,
since code sharing (.so's) cannot take effect here (each jail/VE
has it's completely own tree). 

Now I wonder if it might be possible to let the kernel automatically
find out equal pages and map them together. 

A little compasion showed up that at least 50% of the code could be
shared (maybe more with some tuning, and maybe even data). So it's
(IMHO) really worth it.

Would this be possible ? What had to be done for this ?


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
