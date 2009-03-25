Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZCYWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZCYWg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZCYWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:36:48 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:53327 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZCYWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:36:47 -0400
Date: Wed, 25 Mar 2009 15:36:42 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090325223642.GK7278@localdomain>
References: <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAAD2E.3060904@goop.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:16:14PM -0700, Jeremy Fitzhardinge wrote:
> Ravikiran G Thirumalai wrote:
>> It is already there, and has been there!  But we still need to make
>> vsmp64.c compile only when CONFIG_X86_64 is defined no?
>>   
>
> I still think you should restructure it so that vsmp_64.c only gets 
> compiled with CONFIG_X86_VSMP enabled.  Having all that stuff compiled into 
> every kernel seems pretty pointless.
>

Well, not everything gets compiled in.  Only the is_vsmp_box() logic and
related stuff gets compiled in.  Other paravirt related stuff in vsmp64.c
depends on CONFIG_PARAVIRT.

Thanks,
Kiran
