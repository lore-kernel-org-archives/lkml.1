Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0BUVPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:15:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0BUVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:15:30 -0500
Message-ID: <4B81A308.3020204@redhat.com>
Date: Sun, 21 Feb 2010 16:18:00 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       systemtap <systemtap@sources.redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [Dle-develop] [PATCH -tip 5/9] perf probe: Use elfutils-libdw
 for	analyzing	debuginfo
References: <20100218232701.21679.5195.stgit@dhcp-100-2-132.bos.redhat.com> <20100218232741.21679.22423.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100218232741.21679.22423.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Newer gcc introduces newer & richer debuginfo, and only libdw
> in elfutils project can support it. So perf probe moves onto
> elfutils-libdw from libdwarf.

Hmm, this has some bit-width related issues on x86-64.
I'll update this patch.

Thank you,

-- 
Masami
