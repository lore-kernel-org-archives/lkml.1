Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbZFPXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbZFPXLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZFPXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:11:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39023 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755202AbZFPXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:11:07 -0400
Date: Wed, 17 Jun 2009 00:11:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090617001157.065ee652@lxorguk.ukuu.org.uk>
In-Reply-To: <10437.1245193192@redhat.com>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
	<10437.1245193192@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whilst I might wish to ultimately replace the OpenAFS userspace utilities with
> my own set, that's no small piece of work, and so a handy halfway stage is a
> mixed environment as outlined above.
> 
> Furthermore, the ability to use the OpenAFS userspace utilities unmodified
> with my kernel module, and, indeed vice-versa, makes testing much easier.

But if we add an ABI we end up stuck with it and this one is really
really rather ugly.

Can you not put pioctl() into a C library linked with the openafs
utilities that generates more sensible interface calls ? I mean you have
to produce the pioctl() syscall wrapper anyway so why not make "pioctl" a
user space compat library ?

Alan
