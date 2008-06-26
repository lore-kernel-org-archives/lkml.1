Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYFZRwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYFZRwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYFZRw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:52:29 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23667 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYFZRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:52:28 -0400
X-BigFish: VPS-20(zz1432R98dR62a3L7efV1805Mzz10d3izz5a6ciz32i6bh87il65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K32YBD-01-4L3-01
Date: Thu, 26 Jun 2008 19:09:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: rename setup.c to setup_percpu.c
Message-ID: <20080626170918.GE1620@erda.amd.com>
References: <200806251037.11391.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200806251037.11391.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Jun 2008 17:09:19.0255 (UTC) FILETIME=[5EF6F270:01C8D7AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.08 10:37:11, Yinghai Lu wrote:
>     
>     some functions need to be moved to setup_numa.c
>     after we merge setup32/64.c, some funcs need to be moved back to setup.c
>     
>     Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Yinghai,

x86: rename setup.c to setup_percpu.c:

wouldn't it be sufficient to extend the affected functions with a
*_percpu suffix?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

