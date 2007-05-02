Return-Path: <linux-kernel-owner+w=401wt.eu-S2992964AbXEBJiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992964AbXEBJiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992966AbXEBJiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:38:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:38795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992963AbXEBJiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:38:54 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 2/6] Create asm-i386/cmpxchg.h
Date: Wed, 2 May 2007 11:37:48 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
References: <20070501182157.GA8348@c2.user-mode-linux.org>
In-Reply-To: <20070501182157.GA8348@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021137.48675.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 20:21:57 Jeff Dike wrote:
> Rearrange the i386 cmpxchg code to allow atomic.h to get it without
> needing to include system.h.  This kills warnings in the UML build
> from atomic.h about implicit declarations of cmpxchg symbols.  The
> i386 build presumably isn't seeing this because a separate inclusion
> of system.h is covering it over.
> 
> The cmpxchg stuff is moved to asm-i386/cmpxchg.h, with an include left
> in system.h for the benefit of generic code which expects cmpxchg
> there.
> 
> Meanwhile, atomic.h includes cmpxchg.h.

Doesn't apply against the latest ff tree. Can you please regenerate,
not losing whatever change caused it to reject?

-Andi
