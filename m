Return-Path: <linux-kernel-owner+w=401wt.eu-S937379AbZDIX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937379AbZDIX1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935766AbZDIX1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:27:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936969AbZDIX1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:27:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
References: <20090409232157.13220.63863.stgit@warthog.procyon.org.uk> <20090409232152.13220.28141.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Date: Fri, 10 Apr 2009 00:25:58 +0100
Message-ID: <13314.1239319558@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
> new file mode 100644
> index 0000000..0f8956d
> --- /dev/null
> +++ b/arch/frv/include/asm/Kbuild
> @@ -0,0 +1,5 @@
> +include include/asm-generic/Kbuild.asm
> +
> +header-y += registers.h
> +
> +unifdef-y += termios.h
> diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
> new file mode 100644
> index 0000000..296c35c
> --- /dev/null
> +++ b/arch/frv/include/asm/atomic.h
> @@ -0,0 +1,198 @@
> +/* atomic.h: atomic operation emulation for FR-V
> + *
> ...

Grrr...  It didn't do that when I emailed it to myself.  Seems there's some
more python magic I need to figure out.

David
