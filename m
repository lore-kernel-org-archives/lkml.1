Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYILDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYILDkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 23:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYILDj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 23:39:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYILDj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 23:39:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/13] Turn hrtimers into a range capable timer
Date: Fri, 12 Sep 2008 13:39:49 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
References: <20080901160343.75a89ec9@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121339.49902.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008 09:03:43 Arjan van de Ven wrote:
> This series is a follow-on the the nanosecond select/poll series.
>
> The goal of this series is to introduce the capability into hrtimers to
> deal with a "range" rather than a specific point in time.
> (Several people discussed this recently, but we've been toying with the
> concept for a while)

Hi Arjen, sorry for not replying sooner.

I had half a patch to create a new "timer layer to rule them all" called 
ktimers, which took an explicit "slop" value.  Slop is the "how long before 
its worth waking the machine for this?" value, with friendly SLOP_USECS, 
SLOP_SECONDS, SLOP_DAYS etc defines.  Implemented in terms of normal and hr 
timers, which get deprecated over time.

Heuristics work for a while, but IMHO eventually this is going to have to be 
plumbed through to userspace.

Cheers,
Rusty.
