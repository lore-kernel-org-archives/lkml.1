Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZJZQK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZJZQK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZJZQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:10:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZJZQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:10:54 -0400
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <87tyxmy6x6.fsf@basil.nowhere.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233746.128967000@alcatraz.americas.sgi.com>
	 <87tyxmy6x6.fsf@basil.nowhere.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 12:10:57 -0400
Message-Id: <1256573457.26028.313.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 08:02 +0100, Andi Kleen wrote:

> Also more work could be done to make CPU boot up less verbose without
> sacrifying debuggability if something goes wrong.

What about moving printks over to trace_printk or something. And that
way we can have a "boot up" ring buffer that can later be retrieved if
something goes wrong. It already dumps to the console on panic/oops.

The trace_printk will be hidden and is very fast.

-- Steve


