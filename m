Return-Path: <linux-kernel-owner+w=401wt.eu-S967849AbXHMVKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967849AbXHMVKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbXHMVKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:10:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45772 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbXHMVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:10:20 -0400
Date: Mon, 13 Aug 2007 22:17:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Brad Campbell <brad@wasp.net.au>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Advice on a userspace tty serial driver
Message-ID: <20070813221745.71fdf942@the-village.bc.nu>
In-Reply-To: <20070813205523.GA9412@csclub.uwaterloo.ca>
References: <46BC59E3.2010402@wasp.net.au>
	<20070813205523.GA9412@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think you can do any serial specific stuff, like parity and stop
> bits and the like across a pty.  You might have to actually write a

They will let you do that. Any options you set one side become visible
the other.

Alan
