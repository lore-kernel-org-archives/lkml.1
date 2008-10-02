Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYJBPMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYJBPMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYJBPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:11:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbYJBPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:11:14 -0400
Message-Id: <20081002150529.087488257@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 11:05:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] Clean up patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other kernel developers, I compile kernels several times a day
with various configs. Some are for testing, others are given to me
by others to debug some code.

I like to look at any warnings that gcc gives me, and lately
I've been irritated by the same warnings appearing in the same places
that has nothing to do with my code.

The biggest offender is the Xen code. I figured that I'll take a look at
what these warnings are and if they are trivial, I'll fix them.

The thing that got me when looking into this, is most of the warnings
in Xen come from dead code!  Code that is not called by anyone, or
has references by #if 0 code.

There was one patch from the sound code that only needed a more
robust macro when the debugging was not configured.

The rest of the patches get rid of most of my warnings. There are a
few left where gcc complains about discarding qualifier types but
those are not as trivial to fix, so I'll leave them to those maintainers.

-- Steve

