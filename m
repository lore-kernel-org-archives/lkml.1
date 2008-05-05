Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYEESwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYEESwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765984AbYEESvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:51:17 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:39912 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765977AbYEESvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:51:16 -0400
Date: Mon, 5 May 2008 20:50:13 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505185013.GH32019@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk> <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Miklos Szeredi <miklos@szeredi.hu> wrote:

> You're right. It doesn't sound too good, although it all depends 
> on the how permission checking is done.  If it's done in the server, 
> then neither the mode nor the ownership is needed for lookup. 

It really should be done in the server. But this adds another
issue (no idea if the current 9p driver already handles this):
We need one link for each user accessing the filesystem.


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
