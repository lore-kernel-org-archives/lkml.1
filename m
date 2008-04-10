Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYDJUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYDJUNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYDJUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:13:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33178 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208AbYDJUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:13:35 -0400
Date: Thu, 10 Apr 2008 21:09:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080410210918.3be98868@core>
In-Reply-To: <1207851751-25703-6-git-send-email-giometti@linux.it>
References: <20080410160630.GA24885@enneenne.com>
	<1207851751-25703-1-git-send-email-giometti@linux.it>
	<1207851751-25703-2-git-send-email-giometti@linux.it>
	<1207851751-25703-3-git-send-email-giometti@linux.it>
	<1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
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

On Thu, 10 Apr 2008 20:22:29 +0200
Rodolfo Giometti <giometti@linux.it> wrote:

> Adds support for the PPS sources connected with the CD (Carrier
> Detect) pin of a serial port.

Better and now readable but this is definitely in the wrong place and
should be pushed up the stack so it can be generalised for all serial
devices as an ldisc or similar.

This bit is definitely not ready to go upstream but the general PPS
stuff looks fairly sane.
