Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZKQRWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZKQRWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZKQRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:22:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZKQRWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:22:16 -0500
Date: Tue, 17 Nov 2009 18:21:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64 support for tools/perf/
Message-ID: <20091117172139.GB5967@elte.hu>
References: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> Compiler on ia64 rejects the "-m64" option.
> Add arch specific pieces to perf.h
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Applied, thanks Tony!

> ---
> 
> I expect there is a more elegant solution to the Makefile issue. Feel 
> free to throw away that part of this patch and replace it with 
> something prettier :-)

We looked into including the barrier definition from the kernel header 
but that looks a bit messy too.

Btw., are you planning HAVE_PERF_EVENTS support for IA64? (It's nice 
stuff, i can only recommend it! ;-)

	Ingo
