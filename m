Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZKIJ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZKIJ0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZKIJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:26:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48020 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZKIJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:26:13 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast string.
From: Andi Kleen <andi@firstfloor.org>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
	<4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
	<8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
	<4AF7C66C.6000009@zytor.com>
Date: Mon, 09 Nov 2009 10:26:14 +0100
In-Reply-To: <4AF7C66C.6000009@zytor.com> (H. Peter Anvin's message of "Sun, 08 Nov 2009 23:36:12 -0800")
Message-ID: <87ws2059s9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> My personal opinion is that if we can show no significant slowdown on
> P4, K8, P-M/Core 1, Core 2, and Nehalem then we can simply use this code

The issue is Core 2.

P4 uses a different path, and Core 1 doesn't use the 64bit code.

> unconditionally.  If one of them is radically worse than baseline, then
> we have to do something conditional, which is a lot more complicated.

I have an older patchkit which did this, and some more optimizations
to this code.

There was still one open issue, that is why I didn't post it. If there's
interest I can post it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
