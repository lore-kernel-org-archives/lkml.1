Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZHFW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZHFW6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZHFW6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:58:17 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:33568 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbZHFW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:58:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJv8ekqrR7PE/2dsb2JhbAC5OogqkCcFhBg
X-IronPort-AV: E=Sophos;i="4.43,337,1246838400"; 
   d="scan'208";a="88924495"
From: Roland Dreier <rdreier@cisco.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: drivers/staging/meilhaus build broken with ftrace
References: <ada4oskfwtp.fsf@cisco.com>
	<alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com>
	<20090806222906.GA14792@suse.de>
	<alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com>
	<alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 06 Aug 2009 15:58:15 -0700
In-Reply-To: <alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 6 Aug 2009 18:51:26 -0400 (EDT)")
Message-ID: <adamy6ceeig.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Aug 2009 22:58:15.0381 (UTC) FILETIME=[6194C050:01CA16E9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Now the question is, is this a crucial enough change to push for 31, or 
 > should we leave this for 32?

I would say yes, push it for 31, since a distro is most likely going to
want to enable staging drivers and ftrace, and will hit this build
breakage.

 > This patch is small enough for 31, but to add a warning would require a 
 > little more code rework. I can queue this up for 31 and then have the 
 > warning ready for 32.

Sounds like a good plan.  The warning will probably push someone to
figure out what the meilhaus code is really trying to do.

 - R.
