Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYE2SuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYE2SuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYE2SuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:50:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbYE2SuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:50:09 -0400
Date: Thu, 29 May 2008 19:35:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, dhowells@redhat.com,
       bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] Werror: Hide epca_setup() as it's unused
Message-ID: <20080529193513.0b6811b9@core>
In-Reply-To: <20080529181731.5396.42286.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
	<20080529181731.5396.42286.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 19:17:31 +0100
David Howells <dhowells@redhat.com> wrote:

> Hide epca_setup() by encasing it in #if 0 as it's unused.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

NAK - we don't hide bugs, we fix em.

EPCA setup either needs calling, or as I suspect is the case epca needs
deleting. Hiding the warning isn't useful
