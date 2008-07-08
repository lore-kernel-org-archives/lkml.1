Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYGHQnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYGHQnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYGHQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:43:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34876 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753489AbYGHQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:43:29 -0400
Date: Tue, 8 Jul 2008 17:10:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: jirislaby@gmail.com, akpm@linux-foundation.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a const assignment in moxa_load_fw()
Message-ID: <20080708171029.08db0f4d@the-village.bc.nu>
In-Reply-To: <20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
References: <20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
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

On Tue, 08 Jul 2008 16:44:16 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix an assignment of a const pointer to a non-const pointer in moxa_load_fw().
> 
> This was introduced by patch 037182346f0991683cc7320a257c3f6089432cee.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Alan Cox <alan@redhat.com>
