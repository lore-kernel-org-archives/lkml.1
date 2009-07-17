Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZGQVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZGQVOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbZGQVOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:14:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303AbZGQVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:14:23 -0400
Message-ID: <4A60E9EB.2090206@redhat.com>
Date: Fri, 17 Jul 2009 17:15:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 3/7] Kbuild: disable gcc crossjumping
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212313.5384.84166.stgit@localhost.localdomain> <alpine.DEB.2.00.0906271611280.12592@gandalf.stny.rr.com> <20090717202825.GA6872@merkur.ravnborg.org> <4A60E972.1060301@redhat.com>
In-Reply-To: <4A60E972.1060301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Sam Ravnborg wrote:
>> On Sat, Jun 27, 2009 at 04:13:04PM -0400, Steven Rostedt wrote:
>>> A change like this requires an ACK from Sam Ravnborg.
>>>
>>> -- Steve
>> Overdue review...
>>
>> I do not know the gcc option so I cannot comment on theeffect of it.
> 
> Thanks for comment. however, as far as I can see, I couldn't find

any inter-function jumps populated by crossjump optimization

> in the difference between binary with -fno-crossjump and without it.
> So I decided to drop this patch...

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

