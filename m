Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbZKXQmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbZKXQmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933508AbZKXQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:42:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbZKXQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:42:41 -0500
Message-ID: <4B0C0B50.6000907@zytor.com>
Date: Tue, 24 Nov 2009 08:35:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 07/10] kprobes/x86: Support kprobes jump optimization
 on x86
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 03:22 PM, Masami Hiramatsu wrote:
> 
> This uses stop_machine() for corss modifying code from int3 to jump.
> It doesn't allow us to modify code on NMI/SMI path. However, since
> kprobes itself doesn't support NMI/SMI code probing, it's not a
> problem.
> 

I'm a bit confused by the above statement... does that mean you're
poking int3 and *then* do stop_machine()?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

