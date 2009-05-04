Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZEDM25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZEDM25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZEDM2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:28:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZEDM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:28:47 -0400
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the
 local(mod|yes)config on
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <87fxflgj2q.fsf@basil.nowhere.org>
References: <20090430185022.122124349@goodmis.org>
	 <20090430185223.792841532@goodmis.org>  <87fxflgj2q.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 14:28:06 +0200
Message-Id: <1241440086.7620.4877.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 14:15 +0200, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > Here's the list and order of search:
> >
> >   /proc/config.gz
> >   /boot/vmlinuz-`uname -r`
> >   vmlinux  # local to the directory
> >   /lib/modules/`uname -r`/kernel/kernel/configs.ko
> >   kernel/configs.ko
> >   kernel/configs.o
> >   .config
> 
> 
> That seems like the wrong order. ./.config should always be first for
> compatibility. 
> 
> That order would completely wreck all my build scripts, and I suspect
> others too.

Quite, except that I hardly ever have a ./.config since I make extensive
use of O=foo
