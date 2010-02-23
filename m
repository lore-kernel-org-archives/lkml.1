Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0BWW26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0BWW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:28:56 -0500
Message-ID: <4B845668.5090803@redhat.com>
Date: Tue, 23 Feb 2010 17:27:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v10 0/9] kprobes: Kprobes jump optimization support
References: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com> <1266944834.24271.6021.camel@gandalf.stny.rr.com>
In-Reply-To: <1266944834.24271.6021.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2010-02-18 at 17:12 -0500, Masami Hiramatsu wrote:
> 
>> This version of patch series uses text_poke_smp() which
>> update kernel text by stop_machine(). That is 'officially'
>> supported on Intel's processors. text_poke_smp() can't
>> be used for modifying NMI code,
> 
> But it can be made to use with NMI code. If you look at what I did to
> allow ftrace to modify NMI code, it may be able to do the same thing.

Yeah, I know. But basically, kprobes doesn't support probing NMI.
Maybe, it's possibly the next step. :)

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
