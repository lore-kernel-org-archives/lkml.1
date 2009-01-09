Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZAIVYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZAIVYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZAIVYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:24:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47251 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbZAIVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:24:00 -0500
Date: Fri, 9 Jan 2009 21:24:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and may
 fail without recovery strategy
Message-ID: <20090109212400.5bd1e829@lxorguk.ukuu.org.uk>
In-Reply-To: <20090109205633.GB19904@suse.de>
References: <496798FE.8030900@s5r6.in-berlin.de>
	<20090109205633.GB19904@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It dies a flaming horrible death, pretty much like the whole rest of the
> system if allocating such a small ammount of memory is causing failures
> :)

Now and then I run tests with kmalloc set to randomly fail - the kernel
is suprisingly robust these days.

> Give me a few hours to test here, your change might not be necessary...

The alternative is pretty horrible - mark the function as int and
requiring a return check then start propogating it out and weep at the
gcc warnings...
