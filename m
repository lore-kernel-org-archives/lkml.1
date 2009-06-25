Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbZFYPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbZFYPEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZFYPD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:03:57 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:7111 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZFYPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:03:56 -0400
X-IronPort-AV: E=Sophos;i="4.42,290,1243814400"; 
   d="scan'208";a="205574488"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
References: <1245760130.3776.6.camel@localhost.localdomain>
	<20090623195656.GC8777@elte.hu>
	<1245876060.3038.7.camel@localhost.localdomain>
	<alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
	<20090625092409.GC23547@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 25 Jun 2009 08:03:59 -0700
In-Reply-To: <20090625092409.GC23547@elte.hu> (Ingo Molnar's message of "Thu,
	25 Jun 2009 11:24:09 +0200")
Message-ID: <adabpocl5i8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2009 15:03:59.0571 (UTC) FILETIME=[2B3F3A30:01C9F5A6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Where is the point of this? dL1-loads is a completely non 
 > > intuitive artificial abbreviation.
 > 
 > blame me :)
 > 
 > I found L1-data-Cache-Load-References way too long and i asked for 
 > suggestions and came up with my list of abbreviations.
 > 
 > I found 'dL1' intuitive because we use 'dTLB' and 'iTLB' as well.
 > 
 > How about L1-data-loads ?

I think L1-dcache is a good compromise between length and ease of
understanding (at least for me).

 - R.
