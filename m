Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYJSUzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYJSUzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 16:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYJSUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 16:54:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYJSUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 16:54:59 -0400
Date: Sun, 19 Oct 2008 21:24:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Sergio Luis" <eeeesti@gmail.com>
Cc: "Alan Cox" <alan@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: usb-serial krefs - bad magic number for tty struct (188:0)
Message-ID: <20081019212454.260b0f38@the-village.bc.nu>
In-Reply-To: <ce0170d90810191039i6c78bac1ue1e4b688d47740ff@mail.gmail.com>
References: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
	<ce0170d90810191039i6c78bac1ue1e4b688d47740ff@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd suggest to revert that commit and to review it more carefully.
> What do you people think?

I suggest you demonstrate a little patience. Its a weekend, its a bug
that seems specific to a single device and we've got a ton of time to
nail it.

I'll take a look Tuesday and I don't expect it to take long to pin down -
there will be an unbalanced kref_put somewhere.

Alan
