Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYHST30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYHST30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYHST3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:29:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56631 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYHST3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:29:09 -0400
Message-ID: <48AB1E43.2010408@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 22:25:55 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mpm@selenic.com, tglx@linutronix.de,
       rostedt@goodmis.org, cl@linux-foundation.org, tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <Pine.LNX.4.64.0808191049260.7877@shark.he.net> <20080819175440.GA5435@localhost> <20080819181652.GA29757@Krystal> <20080819183203.GB5520@localhost>
In-Reply-To: <20080819183203.GB5520@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> On Tue, Aug 19, 2008 at 02:16:53PM -0400, Mathieu Desnoyers wrote:
>> Question :
>>
>> Is this kmemtrace marker meant to be exposed to userspace ?
>>
>> I suspect not. In all case, not directly. I expect in-kernel probes to
>> be connected on these markers which will get the arguments they need,
>> and maybe access the inner data structures. Anyhow, tracepoints should
>> be used for that, not markers. You can later put markers in the probes
>> which are themselves connected to tracepoints.
>>
>> Tracepoints = in-kernel tracing API.
>>
>> Markers = Data-formatting tracing API, meant to export the data either
>> to user-space in text or binary format.
>>
>> See
>>
>> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog
>>
>> tracepoint-related patches.
> 
> I think we're ready to try tracepoints. Pekka, could you merge Mathieu's
> tracepoints or otherwise provide a branch where I could submit a
> tracepoint conversion patch for kmemtrace?

Sorry, that's too much of a hassle for me. I'll happily take your 
conversion patch once tracepoints hit mainline. Mathieu, are you aiming 
for 2.6.28?
