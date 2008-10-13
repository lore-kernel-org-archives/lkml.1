Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYJMPsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYJMPsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYJMPr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:47:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbYJMPrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:47:55 -0400
Date: Mon, 13 Oct 2008 16:47:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: GIT head no longer boots on x86-64
Message-ID: <20081013164717.7a21084a@lxorguk.ukuu.org.uk>
In-Reply-To: <1223910693-28693-1-git-send-email-jirislaby@gmail.com>
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org>
	<1223910693-28693-1-git-send-email-jirislaby@gmail.com>
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

> I guess SMP kernel running on UP? In such a case the module .text

Yep

> is patched to use UP locks before the module is added to the modules
> list and it thinks there are no valid data at that place while
> patching.
> 
> Could you test it? The bug disappeared here in qemu. I've checked
> callers of the function, and it should not matter for them.

Seems to do the job.

Jiri 1 Linus 0

;)

