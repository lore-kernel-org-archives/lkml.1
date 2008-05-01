Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbYEAOrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbYEAOrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYEAOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:47:11 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:40067 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571AbYEAOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:47:09 -0400
Date: Thu, 1 May 2008 16:45:01 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080501144500.GE28005@nibiru.local>
Reply-To: weigelt@metux.de
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <Pine.LNX.4.61.0804181331260.29728@dhcppc2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0804181331260.29728@dhcppc2>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:

Hi folks,

<big_snip />

I've just fought through this thread, maybe missed some points, 
and I'll try no to repeat to repeat arguments already said, but:

IMHO, many of the filesystems should belong to userland, 
(especially those I'd call "exotic"). Maybe some decision points:

* high complexity (-> not easy to debug)
* not required for booting 
* not yet matured (within kernel) 
* not performance critical
* requires much userland assistance
* not used permanently (just from time to time)
* not actually an IPC mechanism

My first candidate would be coda: 

It never worked well for me, even often have to reload the 
kernel driver. As most of the logic already *is* in userland, 
there wouldn't be a performance tradeoff when doing the kernel
interface entirely via FUSE or even let venus just be an 9P server.


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
