Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0BWRHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:07:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0BWRHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:07:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=cF7qiyD1qO4A:10 a=7U3hwN5JcxgA:10 a=sNVSGU1_Zl12v9OR0MYA:9 a=qAOzDxDvJczuhZXymEeyqEFti8AA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip v10 0/9] kprobes: Kprobes jump optimization support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Feb 2010 12:07:14 -0500
Message-ID: <1266944834.24271.6021.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 17:12 -0500, Masami Hiramatsu wrote:

> This version of patch series uses text_poke_smp() which
> update kernel text by stop_machine(). That is 'officially'
> supported on Intel's processors. text_poke_smp() can't
> be used for modifying NMI code,

But it can be made to use with NMI code. If you look at what I did to
allow ftrace to modify NMI code, it may be able to do the same thing.

-- Steve


