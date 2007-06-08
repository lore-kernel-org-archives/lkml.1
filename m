Return-Path: <linux-kernel-owner+w=401wt.eu-S969499AbXFHPZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969499AbXFHPZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967788AbXFHPZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:25:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58324 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965675AbXFHPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:25:35 -0400
Date: Fri, 8 Jun 2007 16:30:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
Message-ID: <20070608163018.636b74d1@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 09:29:12 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> The header file <linux/tty_driver.h> should include <asm/termbits.h>
> to pick up the definition of "struct ktermios"; otherwise, you run the
> risk of seeing:

Risk - which compile combinations does it actually show up with and is it
not better to fix the C file in question not grow the horribly tangled
include deps further
