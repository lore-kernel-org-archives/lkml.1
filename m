Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXKGXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXKGXRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXKGXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:17:31 -0500
Received: from mail.suse.de ([195.135.220.2]:59083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbXKGXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:17:30 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Date: Thu, 8 Nov 2007 00:10:44 +0100
User-Agent: KMail/1.9.1
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org>
In-Reply-To: <20071107123045.c6d4b855.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080010.44632.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ow.  Yes, from my reading delay_tsc() can return early (or after
> heat-death-of-the-universe) if the TSCs are offset and if preemption
> migrates the calling task between CPUs.
>
> I suppose a lameo fix would be to disable preemption in delay_tsc().

Yes. Can't think of any better reasonable fix.

-Andi
