Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZFZXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZFZXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZFZXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:18:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51561 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZFZXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:18:18 -0400
Message-ID: <4A4557B2.7080600@redhat.com>
Date: Fri, 26 Jun 2009 19:20:18 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC][ PATCH -tip v2 0/7] kprobes: Kprobes jump optimization
 support
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <87vdmn179n.fsf@basil.nowhere.org> <4A40DDAD.6020202@redhat.com> <87bpoe29jo.fsf@basil.nowhere.org> <4A4110A3.2060808@redhat.com> <20090623203738.GG6760@one.firstfloor.org>
In-Reply-To: <20090623203738.GG6760@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Jun 23, 2009 at 01:28:03PM -0400, Masami Hiramatsu wrote:
>> Hmm, would you know what is the actual name of that section and option?
> 
> -freorder-blocks-and-partition
> 
> .text.unlikely

Hi Andi,

I've built my kernel with -freorder-blocks-and-partition, and
I saw that .text.unlikely contains whole functions, not
pieces of codes. In that case, it doesn't generate jumps which
jump to the middle of other functions.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

