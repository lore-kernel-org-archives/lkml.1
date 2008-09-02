Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYIBA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYIBA6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIBA6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:58:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56592 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbYIBA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:58:06 -0400
Date: Tue, 2 Sep 2008 01:40:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcedeth: option to disable 100Hz timer
Message-ID: <20080902014058.0253cae2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080902024748.5528d1bb@gmail.com>
References: <20080902024748.5528d1bb@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 02:47:48 +0400
Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> On some hardware no TX done interrupts are generated, thus special
> 100Hz timer interrupt is required to handle this situation properly.
> Other device do not require that timer interrupt feature.
> 
> Patch add a "disable_timerirq" option to disable interrupt timer 
> mentioned above. This may be extremely usefull for laptop users.

Is it not possible to detect this case. Do the problem devices just miss
some TX interrupts or generate most but not all ?

Alan
