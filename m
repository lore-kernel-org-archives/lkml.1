Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXITOaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXITOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXITOaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:30:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:51451 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbXITOaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:30:06 -0400
To: satyam@infradead.org
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: error from checkpatch.pl version 0.10
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp>
	<alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
Message-Id: <200709202330.GEH55648.OJQFMFOHtVOFLS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Thu, 20 Sep 2007 23:30:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Satyam Sharma wrote:
> Looks like a checkpatch.pl bug to me -- that was nothing to warn about.
I see. I'll wait for next version.

> 	struct poll_table {
> 		poll_queue_proc qproc;
> 	};
poll_table is defined in include/linux/poll.h .
To change this, we have to do "sed -i -e 's:poll_table:struct poll_table:g'"
against all in-tree files atomically.
Also there would be many out-of-tree files using poll_table.
I think it's too difficult to change.

Thank you.
