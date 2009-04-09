Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbZDIIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbZDIIsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZDIIsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:48:24 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50385 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZDIIsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:48:22 -0400
From: Miles Bader <miles@gnu.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
	<alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
	<20090409030440.GA9169@elte.hu>
Reply-To: Miles Bader <miles@gnu.org>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 09 Apr 2009 17:46:35 +0900
In-Reply-To: <20090409030440.GA9169@elte.hu> (Ingo Molnar's message of "Thu, 9
	Apr 2009 05:04:40 +0200")
Message-ID: <buo1vs2i590.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> We could also up the limit to 90 or 100 columns. My terminals are at 
> 90 columns and that's still pretty ergonomic. 100 is too wide to me 
> personally. (i'd argue that lines longer than 100 fall outside the 
> brain's 'field of view' cache and are beyond a general complexity 
> threshold as well, so they are not efficient to read, regardless of 
> monitor size and quality.)

I agree that _really_ wide lines start to make the code unreadable.

I find 80-column terminals/editor-windows still quite useful because
you can fit two of them side-by-side on almost every display, and I
think it's more useful to have multiple display contexts active than
it is to have huge amounts of whitespace at the ends of all my lines
(after all, comments aside, most code doesn't seem to be all _that_
wide -- the issue here is what happens with the minority that is).

Maybe given a blank slate, 90 columns or so might fit current coding
practices slightly better, but 80-columns seems to still be the
default in many cases (if you just say "xterm" you'll get an 80-column
terminal), and is in practice a very reliable _minimum_, so if you
want to avoid annoying people with hard-wrapping, 80 columns seems
like a pretty reasonable standard width...

-Miles

-- 
Politics, n. A strife of interests masquerading as a contest of
principles. The conduct of public affairs for private advantage.
