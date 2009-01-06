Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZAFQZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZAFQZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZAFQYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:24:53 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58167 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZAFQYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:24:52 -0500
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1231242031.11687.97.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <1231242031.11687.97.camel@twins>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 11:23:43 -0500
Message-Id: <1231259023.4290.159.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49638594.009E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 12:40 +0100, Peter Zijlstra wrote:
> Subject: mutex: adaptive spin
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jan 06 12:32:12 CET 2009
> 
> Based on the code in -rt, provide adaptive spins on generic mutexes.

I already sent Peter details, but the patch has problems without mutex
debugging turned on.  So it isn't quite ready for benchmarking yet.

-chris


