Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZFYPJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZFYPJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZFYPJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:09:36 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:53268 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFYPJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:09:36 -0400
X-IronPort-AV: E=Sophos;i="4.42,290,1243814400"; 
   d="scan'208";a="205577926"
From: Roland Dreier <rdreier@cisco.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
References: <1245760130.3776.6.camel@localhost.localdomain>
	<20090623195656.GC8777@elte.hu>
	<1245876060.3038.7.camel@localhost.localdomain>
	<20090625093346.GD23547@elte.hu>
	<1245934522.5308.39.camel@hpdv5.satnam>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 25 Jun 2009 08:09:38 -0700
In-Reply-To: <1245934522.5308.39.camel@hpdv5.satnam> (Jaswinder Singh Rajput's
	message of "Thu, 25 Jun 2009 18:25:22 +0530")
Message-ID: <ada3a9ol58t.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2009 15:09:39.0068 (UTC) FILETIME=[F59A5BC0:01C9F5A6]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >       266590464  L1d-loads             (scaled from 23.03%)

IMHO "L1d" is too abbreviated for it to be obvious that it means L1 data
cache.  If you want something really short maybe "L1-d$" might be a
little clearer, but I stil like "L1-dcache" best.

The formatting of aligning things is nice defitely but we could also
shorten lines by saying "scaled from" in fewer characters maybe?  (I
have to admit I don't know what "scaled from X%" means in this case so I
can't suggest something better, but the fact that I can't easily tell
what it means probably suggests that the wording could be improved)
