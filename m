Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXEMTAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXEMTAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXEMTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:00:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42013 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbXEMTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:00:05 -0400
Subject: Re: +
	timer_stats-slimmed-down-using-statistics-infrastucture.patch added to -mm
	tree
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mp3@de.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net>
References: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 13 May 2007 11:58:40 -0700
Message-Id: <1179082720.19106.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 17:18 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      timer_stats slimmed down: using statistics infrastucture
> has been added to the -mm tree.  Its filename is
>      timer_stats-slimmed-down-using-statistics-infrastucture.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: timer_stats slimmed down: using statistics infrastucture
> From: Martin Peschke <mp3@de.ibm.com>
> 
> This patch implements timer_stats based on the statistics infrastructure.
> 
> Here is some sample output, which even somewhat
> resembles /proc/timer_stats.
> (>80 char lines because of symbol names, sorry for line breaks).
> 
> It reads:
> <statistic name> <basket> <hits> <label>
> 
> with label being:
> <pid> <task name> <start_fn>(<stop_fn>)
> 
> [root@t2930041 timer_stats]# cat data

this patch changes the userspace API though, and breaks PowerTOP :(

