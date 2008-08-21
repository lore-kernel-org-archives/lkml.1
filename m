Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYHUXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYHUXjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYHUXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:38:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54319 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754817AbYHUXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:38:54 -0400
Date: Fri, 22 Aug 2008 00:20:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: LinuxPPS (RESUBMIT 7): the PPS Linux implementation.
Message-ID: <20080822002002.62ec1914@lxorguk.ukuu.org.uk>
In-Reply-To: <48ADE317.5030809@zytor.com>
References: <1219238170-5508-1-git-send-email-giometti@linux.it>
	<48ADE317.5030809@zytor.com>
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

> 2. I assume that with the PPS line discipline loaded you can still read
>     the data from the main pins on the serial port (almost always used
>     for metadata?)

Yes - thats why the ldisc was done inheriting from the N_TTY discipline.

Alan
