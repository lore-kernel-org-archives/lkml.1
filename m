Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253Ab0ARP7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0ARP7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112Ab0ARP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:59:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0ARP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:59:12 -0500
Message-ID: <4B548521.7000704@redhat.com>
Date: Mon, 18 Jan 2010 10:58:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
In-Reply-To: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> Not really.  For #3 (boosting), you need to know everything for #2,  
> plus be able to compute the length of each instruction -- which we can  
> now do for x86.  To emulate an instruction (#4), you need to replicate  
> what it does, side-effects and all.  The x86 instruction set seems to  
> be adding new floating-point instructions all the time, and I bet even  
> Masami doesn't know what they all do, but so far, they all seem to  
> adhere to the instruction-length rules encoded in Masami's instruction  
> decoder.

Actually, current x86 decoder doesn't support FP(x87) instructions.(even
it already supported AVX) But I think it's not so hard to add it.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

