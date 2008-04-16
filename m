Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYDPCav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYDPCav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYDPCal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:30:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60755 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYDPCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:30:40 -0400
Date: Wed, 16 Apr 2008 11:30:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Tom May" <tom@tommay.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
References: <20080402154910.9588.KOSAKI.MOTOHIRO@jp.fujitsu.com> <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
Message-Id: <20080416113003.A8BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a test program that allocates memory and frees on notification.
>  It takes an argument which is the number of pages to use; use a
> number considerably higher than the amount of memory in the system.
> I'm running this on a system without swap.  Each time it gets a
> notification, it frees memory and writes out the /proc/meminfo
> contents.  What I see is that Cached gradually decreases, then Mapped
> decreases, and eventually the kernel invokes the oom killer.  It may
> be necessary to tune some of the constants that control the allocation
> and free rates and latency; these values work for my system.

really thanks!
I'll test soon :)


