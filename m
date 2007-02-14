Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXBNTlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXBNTlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXBNTlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:41:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXBNTlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:41:14 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org> 
References: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org>  <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 14 Feb 2007 19:40:57 +0000
Message-ID: <7291.1171482057@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >  (1) A cut-down MPI library derived from GPG with error handling added.
> 
> Do we really need to add this?

I presume you mean the MPI library specifically?  If so, then yes.  It's
necessary to do DSA signature verification (or RSA for that matter).

> Wouldn't it be much nicer to just teach people to use one of the existing 
> signature things that we need for _other_ cases anyway, and already have 
> merged?

Existing signature things?  I know not of such beasts, nor can I see them
offhand.

> (Of course, it's possible that none of the current crypto supports any 
> signature checking at all - I didn't actually look. In which case my 
> argument is pointless).

Hashing, yes; encryption, yes; signature checking: no from what I can see.

It's possible that I can share code with eCryptFS, though at first sight that
doesn't seem to overlap with what I want to do.

David
