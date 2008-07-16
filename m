Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYGPIQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYGPIQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYGPIPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:15:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYGPIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:15:48 -0400
Message-ID: <487DAD7A.8080407@jp.fujitsu.com>
Date: Wed, 16 Jul 2008 17:12:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v3
References: <487B05CE.1050508@jp.fujitsu.com>	 <487D78A3.6050105@jp.fujitsu.com> <487D93CD.1000007@qualcomm.com>	 <487D96A2.10904@jp.fujitsu.com>  <487D9A8B.5020005@jp.fujitsu.com> <1216193615.5232.11.camel@twins>
In-Reply-To: <1216193615.5232.11.camel@twins>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I really don't like this, it means the system is really screwed up and
> doesn't deserve to continue.

It can be said that after timeout we just back to previous state, where
machine already limp(=partially screwed up), but have some degree of
performance.  We might be able to do some recovery, such as killing
process, restart or reset of subsystem and so on.  Even if a CPU get
stuck, it might be possible to continue its service with remaining
CPUs, ex. assume there are 1024 CPUs total.
(I wish if we were able to force-reset such unstable CPU in future...)

I agree that there are much amount of situation where this feature is
not acceptable.  But there would be others.

Thanks,
H.Seto
