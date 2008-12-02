Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYLBEpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYLBEpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYLBEo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:44:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36502 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYLBEoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:44:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new function
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <alpine.DEB.1.10.0812011711280.27086@alien.or.mcafeemobile.com>
References: <20081128131311.GC10401@Krystal> <alpine.DEB.1.10.0812011711280.27086@alien.or.mcafeemobile.com>
Message-Id: <20081202134241.1CF4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  2 Dec 2008 13:44:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any thought ?
> 
> That looks fine, but before waving the Thundering Herd flag some 
> performance numbers should be given IMO, considerng also that this is a 
> rather particular use of the poll subsystem.
> Eventually, isn't something like the patch below better than adding custom 
> case names to poll_wait() ALA poll_wait_LONGNAMESFOLLOW()?
> That way you can pass your own queueing function:
> 
> 	poll_wait_qfunc(file, head, pt, add_wait_queue_exclusive);

make sense.
I don't found any bug in your patch.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


Thanks.


