Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYEBK3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYEBK3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYEBK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:28:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55703 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756068AbYEBK2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:28:53 -0400
Date: Fri, 2 May 2008 11:18:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080502111837.588c15ae@core>
In-Reply-To: <20080502073335.GK3002@enneenne.com>
References: <1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core>
	<20080411075515.GH26777@enneenne.com>
	<20080411092840.3cc4de67@core>
	<20080411134724.GF2160@csclub.uwaterloo.ca>
	<20080411154652.4852b6d4@core>
	<20080430114107.GE3002@enneenne.com>
	<20080430172855.6d2e81a6@core>
	<20080502073335.GK3002@enneenne.com>
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

> I see. So what do you suggest to do? Should I add an ldisc to
> register/unregister serial PPS sources and adding function
> tty->ldisc.dcd_change() to manage the events?

I think so. To me that sounds the ideal solution.

Alan
