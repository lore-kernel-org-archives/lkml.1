Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZDTRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZDTRR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZDTRRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:17:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZDTRRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:17:17 -0400
Message-ID: <49ECADAB.4020609@redhat.com>
Date: Mon, 20 Apr 2009 13:15:23 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, h.peter.anvin@intel.com,
       linux-kernel@vger.kernel.org, dannf@hp.com, ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org> <20090410135102.GB24809@elte.hu>
In-Reply-To: <20090410135102.GB24809@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Hm, it would be nice to first unify the relevant bits of 
>arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and then 
>we can apply such patches without duplicative effects.

>	Ingo


Ingo,

Are you OK with consolidating this into arch/x86/kernel/rtc.c as Huang 
Ying had suggested? This seems like the most logical place for the 
rtc-efi init to happen, but your suggestion to consolidate this into 
arch/x86/kernel.time.c may have advantages that I am not aware of. 
Anyway, I would appreciate any insight/opinions on this if you have any. 
Thanks.

Brian

