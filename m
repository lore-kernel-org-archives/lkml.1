Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbXD1PMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbXD1PMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030358AbXD1PMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:12:49 -0400
Received: from quechua.inka.de ([193.197.184.2]:34371 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXD1PMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:12:48 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20070426191835.GA12740@1wt.eu>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HhobO-0003O4-00@calista.eckenfels.net>
Date: Sat, 28 Apr 2007 17:12:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070426191835.GA12740@1wt.eu> you wrote:
>  a) it may do so for a short and bound time, typically less than the
>     maximum acceptable latency for other tasks

if you have n threads in runq and each of them can have m<d (d=max latency
deadline) overhead, you will have to account on d/n slices. This is
typically not possible for larger number of ready threads.

Therefore another aproach would be to make sure the next thread gets a
smaller slice, but then you will have to move around that debit and
distribute it fair, which is the whole problem we face here.

(Besides it is not clear to me if fair scheduling gets the best results, see
the X problem or compare threads vs. process vs. subsystems).

Gruss
Bernd

PS: sorry for that Cc trimming, I need to get rid of my mail2news gateway,
however I will make sure to copy important info to all concerend parties -
dont think thats needed for my ramblings .)


