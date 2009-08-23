Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZHWTeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZHWTeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 15:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbZHWTeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 15:34:15 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51940 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939AbZHWTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hbbLAfFPgp0ue8m09VZPwwD8eBSR2oH1+k9y6V6Wl//MxFdvNH5yDJbx4cYgro/3/t
         4g0L9bXHtTiisprNgak60vHrxxYxjP+6eDkEb7sxL2CBb1SkeWMgDa2GPcDHhAR1t2hZ
         Rw8gzYGhEb634EtPXt4wf9n0aQDDN8OnYIeaE=
Date: Sun, 23 Aug 2009 21:34:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH tracing/kprobes 1/4] x86: Fix x86 instruction decoder
	selftest to check only .text
Message-ID: <20090823193405.GA6256@nowhere>
References: <20090821000108.GC6078@nowhere> <20090821194307.12478.76938.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821194307.12478.76938.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 03:43:07PM -0400, Masami Hiramatsu wrote:
> Fix x86 instruction decoder selftest to check only .text because other
> sections (e.g. .notes) will have random bytes which don't need to be checked.


Applied these 4 patches in

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/kprobes

Thanks!

