Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbZDJTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbZDJTXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZDJTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:23:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41606 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZDJTXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:23:25 -0400
Date: Fri, 10 Apr 2009 21:25:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090410192529.GA25551@uranus.ravnborg.org>
References: <19057.1239370935@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19057.1239370935@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 02:42:15PM +0100, David Howells wrote:
> 
> Move the arch header files from include/asm-mn10300/ to various places in the
> arch headers.  The general headers end up in arch/mn10300/include/asm/ whilst
> the processor- and unit-specific header directories end up in the appropriate
> implementation directories.
> 
> This permits the symlinks include/asm/proc and include/asm/unit to be
> dispensed with.  This does, however, require that #include <asm/proc/xxx.h> be
> converted to #include <proc/xxx.h> and similarly for asm/unit -> unit.
> 
> The following changes since commit 62b8e680e61d3f48f2a12ee248ca03ea8f376926:
>   David Howells (1):
>         MN10300: Kill MN10300's own profiling Kconfig
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-mn10300.git master
> 
> David Howells (2):
>       Move arch headers from include/asm-mn10300/ to arch/mn10300/include/asm/.
>       Separate out the proc- and unit-specific header directories from the general

.gitignore is left in include/asm-mn10300.

As the content of that file is obsoleted by your last patch it can safely be deleted.
Linus - can I ask you to do so?

	Sam
