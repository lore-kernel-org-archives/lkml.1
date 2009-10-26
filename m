Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZJZSvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZJZSvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZJZSvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:51:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbZJZSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:51:07 -0400
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <4AE5E4D3.6060404@sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233746.128967000@alcatraz.americas.sgi.com>
	 <87tyxmy6x6.fsf@basil.nowhere.org>
	 <1256573457.26028.313.camel@gandalf.stny.rr.com> <4AE5E4D3.6060404@sgi.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 14:51:09 -0400
Message-Id: <1256583069.26028.334.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 11:05 -0700, Mike Travis wrote:

> I haven't heard of "trace_printk" but how does this differ from the
> existing kernel log buffer you get with 'dmesg'?
> 

It goes into the ftrace ring buffer and does not print to console. Nor
does it print to dmesg. Currently you need to read ftrace (via the
debugfs) to get to it. Or a sysrq-z will print it out to the console.

-- Steve


