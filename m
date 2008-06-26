Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbYFZNmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbYFZNmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYFZNmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:42:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42608 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751837AbYFZNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:42:39 -0400
Date: Thu, 26 Jun 2008 14:24:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?5aSP5Lqu?= <xiaiaxaxi@sjtu.edu.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can I use yield in this way
Message-ID: <20080626142454.5eddbc8b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080626205650.9ifra13zswgoo0ow@webmail1.sjtu.edu.cn>
References: <20080626205650.9ifra13zswgoo0ow@webmail1.sjtu.edu.cn>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        Can yield() be used as above. After I compile the kernel and  
> run again. Kernel is not working just as it meets deadlock. And if I  
> comment yield(), it runs ok. Could anyone help me?Thanks!

You cannot schedule within an interrupt (the interrupt handler cannot
yield) - you can force a reschedule however, and in theory you could
change the processor masks and trigger a reschedule to do what you want

Alan
