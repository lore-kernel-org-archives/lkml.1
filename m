Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZETWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZETWBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZETWBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:01:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58624 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZETWBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <20090520205805.25003.71314.stgit@localhost.localdomain>
References: <20090520205758.25003.44632.stgit@localhost.localdomain>
	 <20090520205805.25003.71314.stgit@localhost.localdomain>
Date: Thu, 21 May 2009 00:01:24 +0200
Message-ID: <40e92d5b0905201501i1548621xe1ee63aa88129a0@mail.gmail.com>
Subject: Re: [PATCH -tip v6 1/5] x86: instruction decorder API
From: =?ISO-8859-2?Q?Przemys=B3aw_Pawe=B3czyk?= <przemyslaw@pawelczyk.it>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
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

On Wed, May 20, 2009 at 22:58, Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Changes from v5:

> - Use /usr/bin/env to find awk

This is fine, but not in the below case.

> --- /dev/null
> +++ b/arch/x86/scripts/gen-insn-attr-x86.awk
> @@ -0,0 +1,314 @@
> +#!/usr/bin/env awk -f

Depending on multi-argument shebang is IMO bad. In shebang generally
(but not in all systems) everything after interpreter part is treated
as the first argument. Therefore executing your gen-insn-attr-x86.awk
is equivalent to:

/usr/bin/env 'awk -f' gen-insn-attr-x86.awk

which is obviously wrong.

-- 
Przemys³aw Pawe³czyk
