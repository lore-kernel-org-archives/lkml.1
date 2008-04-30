Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbYD3SWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbYD3SWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760913AbYD3SWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:22:11 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19440 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760488AbYD3SWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:22:09 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: Andi Kleen <andi@firstfloor.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
Date: Wed, 30 Apr 2008 20:22:07 +0200
In-Reply-To: <1209577322.25560.402.camel@pmac.infradead.org> (David Woodhouse's message of "Wed, 30 Apr 2008 18:42:02 +0100")
Message-ID: <87bq3rgq40.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2008 18:15:14.0002 (UTC) FILETIME=[22A1B320:01C8AAEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> Andrew Morton has been saying recently that we need an 'embedded
> maintainer', to take responsibility for 'embedded issues' in the core
> kernel, as well as trying to improve our relationship with those using
> the Linux kernel for 'embedded' devices -- who have a reputation of
> not working with us very closely; to their detriment as well as our
> own.

I hope your job description doesn't include adding more and more
CONFIGs though.

I am sure there are lots of low hanging fruit where memory can be
saved and it's a good thing someone cares about that, but please don't
focus on the code size only. Or if you work on that don't do it 
using CONFIG or when you really add a new one find some other 
that is pointless and remove it first. 

There are simply already far too many of them and they make the 
kernel harder and harder to change.

-Andi
