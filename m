Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYJBP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYJBP7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYJBP7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:59:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42892 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753862AbYJBP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:59:21 -0400
Date: Thu, 2 Oct 2008 16:58:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
 disciplines.
Message-ID: <20081002165805.073946ba@lxorguk.ukuu.org.uk>
In-Reply-To: <48E4E805.2030201@zytor.com>
References: <1222933309-2524-1-git-send-email-giometti@linux.it>
	<1222933309-2524-2-git-send-email-giometti@linux.it>
	<1222933309-2524-3-git-send-email-giometti@linux.it>
	<1222933309-2524-4-git-send-email-giometti@linux.it>
	<1222933309-2524-5-git-send-email-giometti@linux.it>
	<1222933309-2524-6-git-send-email-giometti@linux.it>
	<48E4E805.2030201@zytor.com>
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

On Thu, 02 Oct 2008 08:25:57 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Why limit this to just DCD change, and not any of the other status bits 
> (DCD, RI, DSR, CTS)?

We can change that later if anyone wants the other bits. I'm quite happy
with that side of it, the real question is the core code. The tty bits
can then get a spit and polish in the ttydev tree.

Alan
