Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbXGVH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbXGVH4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXGVH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:56:14 -0400
Received: from smtp.nokia.com ([131.228.20.173]:35384 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbXGVH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:56:13 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Igor Stoppa <igor.stoppa@nokia.com>
To: "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: OSSO
Date: Sun, 22 Jul 2007 10:57:02 +0300
Message-Id: <1185091022.19678.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 22 Jul 2007 07:56:03.0497 (UTC) FILETIME=[C04D4190:01C7CC35]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, 2007-07-21 at 23:49 -0700, ext
linux-pm-bounces@lists.linux-foundation.org wrote:
> I'm deliberatly breaking the threading on this so that people who have 
> tuned out the hibernation thread can take a look at this.
> 
> below is the proposal that I made at the bottom of one of the posts on the 
> hibernation thread.

I have the impression that you are trying to describe a mix of the clock
and latency frameworks.

Could you elaborate on how your proposal is incompatible with enhancing
the clock framework? 

It looks like you are proposing a brand new shiny thing that frankly I
would be happy to leave alone, unless it is crystal clear that the clock
fw cannot be improved.

The clocfk fw is used for OMAP and other architectures (including SH,
iirc) and so far it has provided very good support for our power
management needs (Nokia 770 and N800).

Currently we are working on DVFS for OMAP2 (see slides presented at the
linux-pm summit for OLS 2007 http://tinyurl.com/28tact ) and even if the
current prototype is not actively involving the clock fw, our final goal
is to make it capable of supporting atomic transactions for changing the
core parameters.

OMAP3 will require suspend to ram implementation where the content of
system memory is retained, while parts or all the SoC are switched off.
The plan is still to have a clock fw based implementation (plus
interaction with the power rails, of course).

I think these are good examples of the non-ACPI systems you are
mentioning.

To make any proposal that has some chance of being accepted, you have to
compare it against the existing solution, explaining:

-what it is bringing in terms of new functionalities
-how it is different
-why the current implementation cannot simply be enhanced

You can refer to the linux-pm archives for examples of failed attempts
over the last year or so, just search for "framework" in the subject.

-- 
Cheers, Igor

Igor Stoppa <igor.stoppa@nokia.com>
(Nokia Multimedia - CP - OSSO / Helsinki, Finland)
