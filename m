Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZCaLkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZCaLkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZCaLkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:40:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZCaLko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:40:44 -0400
Date: Tue, 31 Mar 2009 07:38:32 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       oleg@redhat.com, adobriyan@gmail.com, mingo@elte.hu,
       torvalds@linux-foundation.org, roland@redhat.com, rostedt@goodmis.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Hellwig <hch@infradead.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090331113832.GG16170@redhat.com>
References: <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain> <20090323151400.GA3413@redhat.com> <20090323214417.GD5814@mit.edu> <20090330151844.8b4eed0f.akpm@linux-foundation.org> <1238491062.28248.2046.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238491062.28248.2046.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Mar 31, 2009 at 11:17:42AM +0200, Peter Zijlstra wrote:

> [...]  Right, from my POV something like utrace is desirable, since
> its basically a huge multiplexer for the debugger state, eventually
> allowing us to have multiple debuggers attached to the same process.
> [...]

Right.

> Then there is this little thing called frysk which uses it, no idea
> what kind of kernel space that needs, nor where it lives -- or for
> that matter, wth it really does ;-)

Frysk was to be a first user of such an improved ptrace(2) API in
order to do the sort of background / multiply-connected debugging, but
that project has been on indefinite hold for about a year.  Instead,
there are experiments under way to extend gdb's backend for that
capability.

- FChE
