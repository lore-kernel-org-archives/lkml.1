Return-Path: <linux-kernel-owner+w=401wt.eu-S965503AbXBOOhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503AbXBOOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXBOOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:37:10 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:52196 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965503AbXBOOhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:37:09 -0500
Date: Thu, 15 Feb 2007 15:35:50 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Message-ID: <Pine.LNX.4.64.0702151530260.14458@scrub.home>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 14 Feb 2007, David Howells wrote:

> Now, this is not a complete solution by any means: the core kernel is not
> protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
> controls) one relatively simple attack vector.

This is really the weak point - it offers no advantage over an equivalent 
implementation in user space (e.g. in the module tools). So why has to be 
done in the kernel?

bye, Roman
