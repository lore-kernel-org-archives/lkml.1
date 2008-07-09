Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYGIPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYGIPMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYGIPM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:12:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42353 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753660AbYGIPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:12:28 -0400
Date: Wed, 9 Jul 2008 15:39:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: alan@redhat.com, akpm@linux-foundation.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the epca driver to permit epca_setup() to be
 invoked from the kernel cmdline
Message-ID: <20080709153906.41711e65@the-village.bc.nu>
In-Reply-To: <20080709131927.639.72528.stgit@warthog.procyon.org.uk>
References: <20080709131927.639.72528.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 14:19:28 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix the epca driver to call epca_setup() if digiepca=xxx is included on the
> command line and the epca driver is built in.
> 
> epca_setup() used to be called from init/main.c in 2.2 kernels, but somewhere
> along the way that call was removed but not replaced.

Acked-by: Alan Cox <alan@redhat.com>

Will add to the ttydev tree.

Alan
