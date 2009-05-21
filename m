Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZEUPuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZEUPuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 11:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZEUPup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 11:50:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58140 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZEUPuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 11:50:44 -0400
Message-ID: <4A1578A5.7090608@redhat.com>
Date: Thu, 21 May 2009 11:52:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: =?UTF-8?B?UHJ6ZW15c8WCYXcgUGF3ZcWCY3p5aw==?= 
	<przemyslaw@pawelczyk.it>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v6 1/5] x86: instruction decorder API
References: <20090520205758.25003.44632.stgit@localhost.localdomain>	 <20090520205805.25003.71314.stgit@localhost.localdomain> <40e92d5b0905201501i1548621xe1ee63aa88129a0@mail.gmail.com> <4A1488A2.30706@redhat.com> <4A14EA86.2060609@zytor.com>
In-Reply-To: <4A14EA86.2060609@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Masami Hiramatsu wrote:
>>> /usr/bin/env 'awk -f' gen-insn-attr-x86.awk
>>>
>>> which is obviously wrong.
>> Oops, right. Anyway, there is no reason that we make it
>> executable because it's always called from Makefile.
>> So, I think just removing that line is better way.
>>
> 
> I suggest leaving in a #!/bin/awk line just for documentation's sake,
> though.

OK, I'd leave that, and change usage line to use awk command
instead of run the script directly.

Thank you!

> 
> 	-hpa
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

