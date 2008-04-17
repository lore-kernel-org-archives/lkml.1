Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbYDQKIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbYDQKIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934173AbYDQJzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:55:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45406 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbYDQJzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:55:14 -0400
Date: Thu, 17 Apr 2008 18:52:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC patch 15/27] Immediate Values - Documentation
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
In-Reply-To: <20080416213552.942797527@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca> <20080416213552.942797527@polymtl.ca>
Message-Id: <20080417184930.A8CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +Memory read:
> +644.09ツア11.39 - 88.16ツア1.35 = 555.93ツア11.46 cycles
> +
> +Getppid without memory pressure:
> +1462.09ツア18.87 - 150.92ツア1.01 = 1311.17ツア18.90 cycles
> +
> +Getppid with memory pressure:
> +17113.33ツア1655.92 - 578.22ツア269.51 = 16535.11ツア1677.71 cycles
> +
> +Therefore, if we add 2 markers not based on immediate values to the getppid
> +code, which would add 2 memory reads, we would add
> +2 * 555.93ツア12.74 = 1111.86ツア25.48 cycles

sorry..

non ascii character is harmful for some language region user.
Couldn't you write ascii only?




