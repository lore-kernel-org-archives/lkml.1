Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbXH0QDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbXH0QDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbXH0P6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:58:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbXH0P6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:58:31 -0400
Message-ID: <46D2F281.5030305@redhat.com>
Date: Mon, 27 Aug 2007 11:49:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH][kprobes] support kretprobe-blacklist
References: <46C5FA48.2050308@redhat.com> <20070827133154.GA22322@infradead.org>
In-Reply-To: <20070827133154.GA22322@infradead.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig wrote:
> On Fri, Aug 17, 2007 at 03:43:04PM -0400, Masami Hiramatsu wrote:
>> This patch introduces architecture dependent kretprobe
>> blacklists to prohibit users from inserting return
>> probes on the function in which kprobes can be inserted
>> but kretprobes can not.
> 
> I don't like this at all.  If people want to shoot themselves into
> their own foot using kernel modules they have an unlimited number
> of ways to do this, and even more with kprobes, so there's no point
> in making it a little harder for some cases.

Would you mean that the kernel need not to check whether the probe
point is safe or not?

Actually, there are many ways to shoot themselves from kernel modules.
Even so, IMHO, it is benefit for people that the kernel rejects at least
those obviously (and known) dangerous operation.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
