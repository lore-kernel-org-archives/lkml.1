Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbXJZT1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbXJZT1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbXJZT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:26:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763913AbXJZT0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:26:50 -0400
Date: Fri, 26 Oct 2007 12:26:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com, dhowells@redhat.com
Subject: Re: [PATCH 1/2] MN10300: Permit AOUT library support to be
 suppressed in ELF binfmt
Message-Id: <20071026122637.f9b86bdd.akpm@linux-foundation.org>
In-Reply-To: <20071026154215.30983.32978.stgit@warthog.procyon.org.uk>
References: <20071026154210.30983.67470.stgit@warthog.procyon.org.uk>
	<20071026154215.30983.32978.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 16:42:15 +0100
David Howells <dhowells@redhat.com> wrote:

> Permit AOUT library support to be suppressed in the ELF binfmt if the arch does
> not support it.  AOUT support is suppressed by adding:
> 
> 	config NO_AOUT_SUPPORT
> 		def_bool y
> 
> to the arch Kconfig file.
> 
> The MN10300 architecture does not support the AOUT binfmt, so the ELF binfmt
> should not be permitted to go looking for AOUT libraries to load.
> 

hm, seems a bit ungainly.  Why can't we just make all the aout things in
binfmt_elf.c depend upon CONFIG_BINFMT_AOUT?

