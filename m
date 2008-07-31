Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYGaSG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYGaSG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYGaSGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:06:19 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:52359 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbYGaSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:06:18 -0400
Date: Thu, 31 Jul 2008 20:06:00 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: high latency NFS
Message-ID: <20080731180600.GA8732@nibiru.local>
Reply-To: weigelt@metux.de
References: <200807241311.31457.shuey@purdue.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807241311.31457.shuey@purdue.edu>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Shuey <shuey@purdue.edu> wrote:
> I'm currently toying with Linux's NFS, to see just how fast it can go in a 
> high-latency environment.  Right now, I'm simulating a 100ms delay between 
> client and server with netem (just 100ms on the outbound packets from the 
> client, rather than 50ms each way).  Oddly enough, I'm running into 
> performance problems. :-)

NFS is *very bad* for latent links.
Try 9p with an little metadata-caching proxy in the middle ;-P

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
