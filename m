Return-Path: <linux-kernel-owner+w=401wt.eu-S1764799AbZDHUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799AbZDHUyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZDHUyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:54:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58283 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZDHUyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:54:13 -0400
Date: Wed, 8 Apr 2009 22:56:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: jeremy@goop.org, mingo@elte.hu, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Message-ID: <20090408205610.GA9970@uranus.ravnborg.org>
References: <20090408184455.GB332@uranus.ravnborg.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk> <24317.1239216477@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24317.1239216477@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 07:47:57PM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Any change we can have these header files moved before too
> > many patches are queued?
> 
> Sure.  Do you have patches to move FRV and MN10300 headers?

For frv it is as simple as:

mkdir -p arch/frv/include/asm
git mv include/asm-frv/* arch/frv/include/asm
git commit

For mn10300 Al Viro sent a set of patches some months ago.
Google turned up the following:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/00826.html
http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/00827.html

I did not try - but I assume they would apply almost clean today.

	Sam
