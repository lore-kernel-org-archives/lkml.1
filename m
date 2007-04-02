Return-Path: <linux-kernel-owner+w=401wt.eu-S965948AbXDBVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965948AbXDBVt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965958AbXDBVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:49:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:5532 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbXDBVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:49:56 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
X-Message-Flag: Warning: May contain useful information
References: <4611652F.700@zytor.com> <adaslbiecxg.fsf@cisco.com>
	<46116898.5050701@zytor.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 02 Apr 2007 14:49:55 -0700
In-Reply-To: <46116898.5050701@zytor.com> (H. Peter Anvin's message of "Mon, 02 Apr 2007 13:33:28 -0700")
Message-ID: <adak5wue9a4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2007 21:49:55.0669 (UTC) FILETIME=[D9F29850:01C77570]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > > Obviously, anyone who adheres to the published interface can
 > > > use one of these VID:DIDs -- as far as I'm concerned, even
 > > > hardware vendors; we'll use the SID to distinguish between
 > > > implementations.

 > > I think for this to work, some attempt at a conformance testing
 > > program is required...

 > How would you propose one goes about that?  It seems to me the only
 > plausible thing is "does it work with the unmodified driver included
 > in the Linux kernel?"  What else can one realistically do?

Well, even "works with the Linux driver" can be formalized with a test
plan that describes how to say it works.  But one can also imagine a
test harness that drives the virtual hardware with synthetic test data
and makes sure it does what it's supposed to.

It also helps when writing the spec to try and write lots of anal
"compliance statements" that can be tested in the suite.

But really, I just think we need a stick to shake at people to force
them to fix bugs in their virtual devices, to avoid a big mess of
quirks that defeats the purpose of the whole exercise.

 - R.
