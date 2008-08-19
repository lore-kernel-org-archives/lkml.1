Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYHSWM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYHSWM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYHSWMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:12:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46055 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbYHSWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:12:07 -0400
Date: Tue, 19 Aug 2008 22:53:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
 disciplines.
Message-ID: <20080819225322.69f3215d@lxorguk.ukuu.org.uk>
In-Reply-To: <1219182612-13814-6-git-send-email-giometti@linux.it>
References: <1219182612-13814-1-git-send-email-giometti@linux.it>
	<1219182612-13814-2-git-send-email-giometti@linux.it>
	<1219182612-13814-3-git-send-email-giometti@linux.it>
	<1219182612-13814-4-git-send-email-giometti@linux.it>
	<1219182612-13814-5-git-send-email-giometti@linux.it>
	<1219182612-13814-6-git-send-email-giometti@linux.it>
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

> + * void (*dcd_change)(struct uart_port *port, unsigned int status,
> + * 			struct timespec *ts)
> + *
> + *	Tells the discipline that the DCD pin has changed its status and
> + *	the relative timestamp. Pointer ts can be NULL.
>   */

uart_port is a specific property of a few random types of interface, pass
a tty struct up. Otherwise looks fine. Might one day expand it to a more
generic change type and pass info on what changed but thats a future
mystery.
