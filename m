Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZEMJfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZEMJfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZEMJfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:35:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:43623 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZEMJfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090513082310.GQ18554@redhat.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
	 <20090509004841.5505.48140.stgit@localhost.localdomain>
	 <20090513082310.GQ18554@redhat.com>
Date: Wed, 13 May 2009 11:35:16 +0200
Message-ID: <40e92d5b0905130235p2c60bd56y4f001247e11d6302@mail.gmail.com>
Subject: Re: [PATCH -tip v5 1/7] x86: instruction decorder API
From: =?ISO-8859-2?Q?Przemys=B3aw_Pawe=B3czyk?= <przemyslaw@pawelczyk.it>
To: Gleb Natapov <gleb@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:23, Gleb Natapov <gleb@redhat.com> wrote:
> On Fri, May 08, 2009 at 08:48:42PM -0400, Masami Hiramatsu wrote:
>> +++ b/arch/x86/scripts/gen-insn-attr-x86.awk
>> @@ -0,0 +1,314 @@
>> +#!/bin/awk -f
> On some distributions (debian) it is /usr/bin/awk.

True, but on most of them (all?) there is also an appropriate link in /bin.
If shebang could have more that one argument, then '/usr/bin/env awk
-f' would be the best solution I think.

-- 
Przemys³aw Pawe³czyk
