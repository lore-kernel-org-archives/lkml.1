Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYDKOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYDKOvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYDKOvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:51:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60376 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758193AbYDKOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:51:44 -0400
Date: Fri, 11 Apr 2008 15:46:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080411154652.4852b6d4@core>
In-Reply-To: <20080411134724.GF2160@csclub.uwaterloo.ca>
References: <20080410160630.GA24885@enneenne.com>
	<1207851751-25703-1-git-send-email-giometti@linux.it>
	<1207851751-25703-2-git-send-email-giometti@linux.it>
	<1207851751-25703-3-git-send-email-giometti@linux.it>
	<1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core>
	<20080411075515.GH26777@enneenne.com>
	<20080411092840.3cc4de67@core>
	<20080411134724.GF2160@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought it just required that the uart driver call
> uart_handle_dcd_change when the state of the CD changes, and all the PPS
> stuff happened in that function.

uart_ is only used by some drivers. We have a whole army of drivers using
the tty layer directly and another army of drivers using the USB layer.

You also need a sensible way to talk to the devices, identify support and
avoid clashing uses of carrier pins.

Alan
