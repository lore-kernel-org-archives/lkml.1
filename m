Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZJZHFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZJZHFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZJZHFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:05:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZJZHFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:05:15 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
From: Andi Kleen <andi@firstfloor.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233756.941535000@alcatraz.americas.sgi.com>
Date: Mon, 26 Oct 2009 08:05:19 +0100
In-Reply-To: <20091023233756.941535000@alcatraz.americas.sgi.com> (Mike Travis's message of "Fri, 23 Oct 2009 18:37:49 -0500")
Message-ID: <87ljiyy6s0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Limit number of microcode messages of the form:
>
> [   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001

Having a summary message that tells how many CPUs got updated at the
end would seem like the right approach here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
