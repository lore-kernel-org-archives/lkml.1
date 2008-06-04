Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYFDL7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYFDL7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYFDL7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:59:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35847 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbYFDL7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:59:17 -0400
Date: Wed, 4 Jun 2008 12:43:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, David Brownell <david-b@pacbell.net>,
       pavel@suse.cz, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] add a printk_init variant storing format strings in
 __initdata
Message-ID: <20080604124336.578d86ae@core>
In-Reply-To: <20080604011607.15dec5a7.akpm@linux-foundation.org>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	<1212485252.0@pinky>
	<20080604011607.15dec5a7.akpm@linux-foundation.org>
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

> > When using printk from __init functions it would be desirable to place
> > the printk format strings in __initdata.  Add a printk_init() variant
> > which does this.

Russell played with this years ago I seem to remember and broke the ARM
gcc in the process. If we have any compilers generating near pointer
references for string constants then suddenely hiding them in another
section is going to be interesting.

> Wouldn't it be great if checkpatch were to detect
> fail-to-use-printk_init() in an __init function?

Can we have a 'correctpatch' to go with it someday perhaps ;)
