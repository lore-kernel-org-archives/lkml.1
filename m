Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZA2RYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZA2RYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZA2RYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:24:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZA2RYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:24:21 -0500
Date: Thu, 29 Jan 2009 12:24:06 -0500
From: Dave Jones <davej@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Xiaoning Ding <dingxn@ymail.com>, linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
	processors
Message-ID: <20090129172406.GB14096@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>, Xiaoning Ding <dingxn@ymail.com>,
	linux-kernel@vger.kernel.org
References: <603382.20833.qm@web59902.mail.ac4.yahoo.com> <20090128210200.GA19527@redhat.com> <4981A0AC.5030300@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4981A0AC.5030300@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 03:27:24PM +0300, Michael Tokarev wrote:

 > > p4-clockmod doesn't change the processor frequency.
 > 
 > Hmm..  But what it really does, then?

it modulates the clock so the CPU isn't always availble for doing work.

 > I used it one one machine which had a flaky CPU cooler,
 > to reduce power consumption during hot summer days.

it reduces the amount of heat generated, by making jobs
take longer to finish. This comes at a cost of the CPU not
being able to enter lower C states for longer periods of time,
so you may end up actually using *more* power.

 > It worked, and reportedly the frequency varied from
 > 200MHz to the max of 2.4GHz (it's a P4 Xeon).

The CPU was always at 2.4GHz, even if it said '200MHz'.
It was just only doing work once in every 12 clocks.

	Dave

-- 
http://www.codemonkey.org.uk
