Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYFSIzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYFSIzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYFSIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:55:22 -0400
Received: from aun.it.uu.se ([130.238.12.36]:48706 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYFSIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:55:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18522.6552.622680.92788@harpo.it.uu.se>
Date: Thu, 19 Jun 2008 10:32:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
In-Reply-To: <20080619081146.GC17630@cs181133002.pp.htv.fi>
References: <4859F075.2050207@linux.intel.com>
	<21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
	<20080619081146.GC17630@cs181133002.pp.htv.fi>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:
 > On Thu, Jun 19, 2008 at 03:42:34PM +1000, Dave Airlie wrote:
 > > On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
 > > > In the kerneloops.org stats, a new oops is rapidly climbing the charts.
 > > > The oops is a page fault in the ext3 "do_slit" function, and the first
 > > > report of it was with 2.6.26-rc6-git3.
 > > >
 > > > It happens with various applications; the backtraces are at:
 > > >
 > > > http://www.kerneloops.org/search.php?search=do_split
 > > 
 > > This is a bug in rawhide in gcc miscompiling something...
 > > 
 > > https://bugzilla.redhat.com/show_bug.cgi?id=451068
 > 
 > If I understand it correctly that's a bug in upstream gcc 4.3.1
 > (but not in gcc 4.3.0)?
 > 
 > Expect a lot more of this to pop up in the future.
 > Should we #error for gcc 4.3.1?

There are other nasty bugs in gcc-4.3.0. I actually
had to completely ban 4.3.0 in a user-space project
I'm involved with (Erlang) due to gcc PR36339 (fixed
in 4.3.1).

What's the gcc bugzilla number for this new 4.3.1 bug?
