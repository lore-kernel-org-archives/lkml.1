Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbYDKRbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbYDKRbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbYDKRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:31:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:13923 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbYDKRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X11tLVb4smjnqK7mausQ5k9EO7j0w2XgIStE2I7UJ050fkAMWbXfhflFlTSfWQb62koGtRVl3uUsqFwx3CnXvxUO1gaRwORmVVviHR1JHmDHD2ChdF2hTklfuHBphMy0iQiiuQAbMrLbobYoFSiogr0ogj2xDe9bCp13n/v+GO4=
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <2225.1207929050@redhat.com>
References: <1207927166.22001.91.camel@brick>
	 <1207885132.22001.85.camel@brick> <15208.1207908688@redhat.com>
	 <2225.1207929050@redhat.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 10:31:39 -0700
Message-Id: <1207935099.22001.94.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 16:50 +0100, David Howells wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Consistency with every other arch..no other reason.
> 
> But not M68K(NOMMU), Alpha, Blackfin, Cris, H8300, MN10300, ..., but generally
> consistent with the other FRV headers (some other people have added differ).
> 
> Hmmm...  It looks like MIPS is weird.  That says __ASM_GENERIC_UNALIGNED_H,
> which is probably wrong.
> 
> David

Well, now's the time to decide on something as I'm changing every arch.

What is the general pattern used for this kind of thing?  Or am I just
asking what color to paint this bikeshed?

Harvey

