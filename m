Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYIBWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYIBWev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYIBWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:34:44 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:49365 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYIBWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:34:43 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217808000"; 
   d="scan'208";a="21202843"
From: Roland Dreier <rdreier@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
References: <200809030021.00122.hverkuil@xs4all.nl>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 02 Sep 2008 15:34:42 -0700
In-Reply-To: <200809030021.00122.hverkuil@xs4all.nl> (Hans Verkuil's message
	of "Wed, 3 Sep 2008 00:20:59 +0200")
Message-ID: <ada7i9ufa7x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Sep 2008 22:34:42.0433 (UTC) FILETIME=[17C67F10:01C90D4C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > 2) No, never use the 'if (a) b;' construction. Put 'b;' on the next line 
 > instead.

This is correct.  Always write simple if statements as

	if (a)
		b;

 > And in general, why is this:
 > 
 > if (a) {
 > 	b;
 > }
 > 
 > not accepted by the CodingStyle? (At least as I understand it)

The braces take up another line of whitespace, which means less code
fits on the screen.  And in simple cases, they don't add anything.
Finally, the vast majority of the kernel leaves the braces off, so they
look funny to people who read a lot of kernel code.

And uniformity counts for a lot: most coding style rules are completely
arbitrary, but having a uniform kernel style makes reading kernel code
much easier.

Keep in mind that common sense always trumps any mechanical rule.  So if
there is some case where writing

	if (a) {
		b;
	}

is clearly easier to read than leaving the braces off, then that would
be OK.

 - R.
