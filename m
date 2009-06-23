Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZFWWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZFWWGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZFWWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:06:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54813 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZFWWGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:06:37 -0400
Message-ID: <4A415258.6030603@redhat.com>
Date: Tue, 23 Jun 2009 18:08:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
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
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090623114252.GB9497@elte.hu> <4A40E153.9030704@redhat.com> <20090623194009.GA8777@elte.hu> <4A414F0D.3020805@redhat.com>
In-Reply-To: <4A414F0D.3020805@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>> Plus i'd suggest a runtime control (a sysctl) as well - if it's not 
>> too intrusive. Since this is an optional speedup feature, distros 
>> can have this enabled and if there's some problem with it then it 
>> can still be disabled in sysctl.conf, without having to rebuild the 
>> kernel.
> 
> The runtime control is a good idea. Btw, current kprobes already has
> a runtime disable interface under sysfs. Is there any reason that we'd
> better to use sysctl instead of sysfs?

Oops, s/sysfs/debugfs/g.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

