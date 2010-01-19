Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792Ab0ASJOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0ASJOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487Ab0ASJOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:14:20 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59715 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0ASJOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:14:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: Memory allocations in .suspend became very unreliable)
Date: Tue, 19 Jan 2010 10:15:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-mm" <linux-mm@kvack.org>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1263745267.2162.42.camel@barrios-desktop> <20100118111703.AE36.A69D9226@jp.fujitsu.com> <201001182206.36365.rjw@sisk.pl>
In-Reply-To: <201001182206.36365.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191015.00470.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. Januar 2010 22:06:36 schrieb Rafael J. Wysocki:
> I was concerned about another problem, though, which is what happens if the
> suspend process runs in parallel with a memory allocation that started earlier
> and happens to do some I/O.  I that case the suspend process doesn't know
> about the I/O done by the mm subsystem and may disturb it in principle.

How could this happen? Who would allocate that memory?
Tasks won't be frozen while they are allocating memory.

	Regards
		Oliver
