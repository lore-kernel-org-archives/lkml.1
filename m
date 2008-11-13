Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYKML6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYKML6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYKML6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:58:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40845 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYKML6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:58:16 -0500
Message-ID: <491C164F.4030907@jp.fujitsu.com>
Date: Thu, 13 Nov 2008 20:58:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] accelerate newidle balancing in relax_domain
References: <491C0A01.5040106@jp.fujitsu.com> <20081113111040.GA26461@elte.hu>
In-Reply-To: <20081113111040.GA26461@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I agree with making it more sensitive to momentary load fluctuations. 
> (as long as other metrics do not degrade).
> 
> But this solutin basically overrides the newidle_idx tuning in 
> topology.h.
> 
> Is there a strong reason to do this tuning dynamically, or could we 
> just decrease newidle_idx in the appropriate templates in the 
> topology.h files?

IMHO topology.h should have proper values that will fit 'standard'
system usage.  I'm not sure that the current values (such as 2 in
SD_NODE) is best number or not... And I think it can differ by archs.

If there are no features that will be affected by the changing
default newidle_idx values, then we can fix it in the templates.
It would be a strong reason - I don't like regression :-)


Thanks,
H.Seto

