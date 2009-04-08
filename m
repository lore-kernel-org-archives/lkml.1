Return-Path: <linux-kernel-owner+w=401wt.eu-S934695AbZDHSnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695AbZDHSnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763775AbZDHSmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:42:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:49976 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZDHSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:42:51 -0400
Date: Wed, 8 Apr 2009 20:44:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: jeremy@goop.org, mingo@elte.hu, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Message-ID: <20090408184455.GB332@uranus.ravnborg.org>
References: <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 07:30:11PM +0100, David Howells wrote:
> asm-frv/pgtable.h could just #include <asm-generic/pgtable.h> in NOMMU mode
> rather than #defining macros for lazy MMU and CPU stuff.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/asm-frv/pgtable.h |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
> index e16fdb1..3323301 100644
> --- a/include/asm-frv/pgtable.h
> +++ b/include/asm-frv/pgtable.h

Any change we can have these header files moved before too
many patches are queued?

	Sam
