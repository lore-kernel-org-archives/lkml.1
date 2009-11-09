Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZKISyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZKISyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZKISya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:54:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZKISya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:54:30 -0500
Date: Mon, 9 Nov 2009 19:54:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Ma, Ling" <ling.ma@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Message-ID: <20091109185434.GH26740@basil.fritz.box>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <87ws2059s9.fsf@basil.nowhere.org> <4AF84640.7010705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF84640.7010705@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ling's numbers didn't seem to show a significant slowdown on Core 2 (it
> was something like 0.95x baseline in the worst case, and most of the
> cases were positive) so Core 2 doesn't seem to have a problem.

I ran quite a lot of micro benchmarks with various alignments and sizes
the 'q' variant was not always a win. I haven't checked that particular
version though.

There's also K8 of course.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
