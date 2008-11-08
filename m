Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYKHO1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYKHO1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKHO06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:26:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34998 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752984AbYKHO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:26:57 -0500
Date: Sat, 8 Nov 2008 14:27:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mathias.schnarrenberger@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during kernel
 bootup
Message-ID: <20081108142705.59c1ced7@lxorguk.ukuu.org.uk>
In-Reply-To: <200811081100.03966.mathias.schnarrenberger@gmx.de>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de>
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

> So, I think it would be good if the kernel clears the keyboard buffer during boot up (at least in x86-based systems) to protect the users password. I don't know anything about EFI-based systems and other architectures.
> Because I'm not sure where to implement the code to delete the keyboard buffer in the kernel, I can't make a proper patch. Possibly one of you can do this ;)

Clear it with a program if it bothers you. You've written 90% of the
needed code with the program below.


Alan
