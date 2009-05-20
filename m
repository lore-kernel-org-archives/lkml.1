Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZETWqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZETWqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZETWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:46:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZETWqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:46:21 -0400
Message-ID: <4A1488A2.30706@redhat.com>
Date: Wed, 20 May 2009 18:48:02 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Przemys=B3aw_Pawe=B3czyk?= <przemyslaw@pawelczyk.it>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v6 1/5] x86: instruction decorder API
References: <20090520205758.25003.44632.stgit@localhost.localdomain>	 <20090520205805.25003.71314.stgit@localhost.localdomain> <40e92d5b0905201501i1548621xe1ee63aa88129a0@mail.gmail.com>
In-Reply-To: <40e92d5b0905201501i1548621xe1ee63aa88129a0@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Przemys³aw Pawe³czyk wrote:
> On Wed, May 20, 2009 at 22:58, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Changes from v5:
> 
>> - Use /usr/bin/env to find awk
> 
> This is fine, but not in the below case.
> 
>> --- /dev/null
>> +++ b/arch/x86/scripts/gen-insn-attr-x86.awk
>> @@ -0,0 +1,314 @@
>> +#!/usr/bin/env awk -f
> 
> Depending on multi-argument shebang is IMO bad. In shebang generally
> (but not in all systems) everything after interpreter part is treated
> as the first argument. Therefore executing your gen-insn-attr-x86.awk
> is equivalent to:
> 
> /usr/bin/env 'awk -f' gen-insn-attr-x86.awk
> 
> which is obviously wrong.

Oops, right. Anyway, there is no reason that we make it
executable because it's always called from Makefile.
So, I think just removing that line is better way.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

