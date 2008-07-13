Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYGMKnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYGMKnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 06:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGMKnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 06:43:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52492 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753919AbYGMKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 06:43:34 -0400
Date: Sun, 13 Jul 2008 11:25:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Message-ID: <20080713112543.2dc9d6f7@lxorguk.ukuu.org.uk>
In-Reply-To: <200807130127.36706.jozwicki@aster.pl>
References: <200807130127.36706.jozwicki@aster.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 01:27:36 +0200
"Jakub W. Jozwicki" <jozwicki@aster.pl> wrote:

> Change locking surrounding kmap_atomic from local_irqsave to 
> local_irqsave_nort. This fixes issues with PREEMPT_RT.
>  
> Signed-off-by:  Jakub Jozwicki <jozwicki@aster.pl>

The right way to fix this is to use a bounce buffer. I sent Jeff patches
to do that a couple of times. I'm not sure what has happened to them
since ? So NAK this, we should apply the patch to actually fix the bug
instead.

Jeff ?

Alan
