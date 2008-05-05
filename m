Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbYEETEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbYEETEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763357AbYEETDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:03:19 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:43430 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761714AbYEETDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:03:17 -0400
Date: Mon, 5 May 2008 21:02:43 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505190243.GI32019@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk> <20080505182308.GG32019@nibiru.local> <20080505183420.GQ5882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505183420.GQ5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> How _can_ server resolve symlinks, when result of symlink 
> resolution depends on where the damn thing is mounted on client 
> and even how deeply the process trying to do lookup happens 
> to be chrooted?

In the same way as, eg. http servers, do. Of course this fails 
if the symlink isn't resolvable within server's fs.

Several years ago, I've seen exactly this behaviour on Samba.
Whether this is what you might expect, is another story ;-P

> > Naive question: is it really *necessary* to have all the 
> > intermediate dirs in dcache ?
> 
> The answer's "yes".

What exactly are they needed for ? 
Which information is needed ?
Can we perhaps fake them (at least we know - on success - the
intermediate components are dirs) ?


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
