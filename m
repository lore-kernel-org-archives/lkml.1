Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbZCYSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbZCYSv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbZCYSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:51:45 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:42280 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbZCYSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:51:44 -0400
Date: Wed, 25 Mar 2009 11:51:38 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090325185138.GI7278@localdomain>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324091035.GA6605@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:10:35AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> Sure.  Here's a revert, it is a partial revert which compiles 
>> vsmp64.c only for 64bit architectures.
>
>hm, why dont you add 'depends on X86_64' to the X86_VSMP Kconfig 
>rules? That's far clear - or am i missing some detail?

It is already there, and has been there!  But we still need to make
vsmp64.c compile only when CONFIG_X86_64 is defined no?

Thanks,
Kiran
