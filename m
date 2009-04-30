Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbZD3Nr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbZD3Nr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZD3NrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:47:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZD3NrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:47:10 -0400
Date: Thu, 30 Apr 2009 09:47:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/3] removing unwanted module configs
In-Reply-To: <alpine.DEB.2.00.0904300932380.20374@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904300945440.20374@gandalf.stny.rr.com>
References: <20090430030821.523327994@goodmis.org> <20090430071830.GC16737@elte.hu> <alpine.DEB.2.00.0904300908110.20374@gandalf.stny.rr.com> <20090430132605.GA5289@elte.hu> <alpine.DEB.2.00.0904300932380.20374@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Apr 2009, Steven Rostedt wrote:
> 
> Since this option can also be used for helping embedded developers (I used 
> it for that) I would not want to bloat the kernel with running a script 
> that is suppose to minimize it. But if IKCONFIG && !IKCONFIG_PROC does not 
> add more data to the kernel, then I would be happy to turn it on by 
> default.

Actually, I can let the user decide. If it sees that IKCONFIG is not set, 
it can remove it from the .config output. When the silentoldconfig runs 
afterwards, it will ask the user if they want to enable it.

-- Steve

