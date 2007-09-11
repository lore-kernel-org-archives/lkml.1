Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbXIKKaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbXIKKaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762940AbXIKKao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:30:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47442 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755310AbXIKKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:30:43 -0400
Date: Tue, 11 Sep 2007 11:38:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mkrameshid <mkrameshid@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Calling PnP bios routines like get device node from x86_84 arch
Message-ID: <20070911113832.72541a2a@the-village.bc.nu>
In-Reply-To: <46E6B8E5.2030405@gmail.com>
References: <12594726.post@talk.nabble.com>
	<20070910173344.4bd2ae9e@the-village.bc.nu>
	<46E675E6.1040105@gmail.com>
	<20070911105108.6d68a347@the-village.bc.nu>
	<46E6B8E5.2030405@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 21:18:53 +0530
mkrameshid <mkrameshid@gmail.com> wrote:

> Can I call the BIOS function using ACPI . I didn't work on it.
> If I asked a silly question please for give me. I am very new to this.

ACPI replaces the BIOS functions you are trying to use. You *can't* use
those BIOS functions. Not only is there no code for it but it isn't valid
to do so if the operating system is using ACPI.

Instead ACPI provides all the needed device enumerations by its own
method.
