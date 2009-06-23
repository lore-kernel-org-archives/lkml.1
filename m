Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZFWUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZFWUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZFWUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:37:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFWUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:37:38 -0400
Date: Tue, 23 Jun 2009 22:37:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC][ PATCH -tip v2 0/7] kprobes: Kprobes jump optimization support
Message-ID: <20090623203738.GG6760@one.firstfloor.org>
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <87vdmn179n.fsf@basil.nowhere.org> <4A40DDAD.6020202@redhat.com> <87bpoe29jo.fsf@basil.nowhere.org> <4A4110A3.2060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4110A3.2060808@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:28:03PM -0400, Masami Hiramatsu wrote:
> Hmm, would you know what is the actual name of that section and option?

-freorder-blocks-and-partition

.text.unlikely

> I think another possible solution is decoding those sections and
> black-listing the target functions when making vmlinux or loading
> modules.

Note that this can be pretty much all functions if you're unlucky.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
