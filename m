Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZKRQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZKRQ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZKRQ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:56:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:60734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731AbZKRQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:56:37 -0500
Subject: RE: [PATCH] ia64 support for tools/perf/
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E3876A5B@orsmsx505.amr.corp.intel.com>
References: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
	 <20091117172139.GB5967@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E3876A5B@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:56:36 +0100
Message-ID: <1258563396.3918.698.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 09:25 -0800, Luck, Tony wrote:
> > Btw., are you planning HAVE_PERF_EVENTS support for IA64? (It's nice 
> > stuff, i can only recommend it! ;-)
> 
> My first goal is getting the s/w events hooked up and working.  I'm still
> wondering about how to get the h/w counters to co-exist with perfmon (which
> has been part of ia64 API for many years).

A first approach could be to make them mutually exclusive at runtime.
When there's a perf_event user, perfmon users get FAIL and vs.

This is basically the state for x86 perf_event vs oprofile atm.

