Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYC1Brq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYC1Brq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYC1Bri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:47:38 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:55983 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYC1Bri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:47:38 -0400
Date: Fri, 28 Mar 2008 02:46:58 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
Message-ID: <alpine.DEB.1.10.0803280246530.3955@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Thomas Gleixner wrote:
> I had a lengthy bug decoding session with Ingo and we found the root
> cause:
> A dropped workaround for the prefetch bug in early X2s and
> Opterons. Patch below.

Although I reported it, I could not repoduce the bug. Anyway, I've applied 
your patch to -rc7 and no BUG so far :)

Thanks!
Christian.
-- 
BOFH excuse #385:

Dyslexics retyping hosts file on servers
