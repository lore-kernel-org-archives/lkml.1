Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYLESQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYLESQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbYLESQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:16:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47097 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755825AbYLESQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:16:09 -0500
Date: Fri, 5 Dec 2008 18:16:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
In-Reply-To: <20081205180350.GA25236@ioremap.net>
References: <20081205180350.GA25236@ioremap.net>
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

On Fri, 5 Dec 2008 21:03:50 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Hi.
> 
> I've built current (aaad07763) git tree with config, which worked ok
> with 2.6.27 (pressed enter several times when 'make oldconfig' asked)
> and now system fails to boot.
> 
> Attached screen dump and config.
> 
> I'm not subscribed, please add to copy.

Your modprobe is for some reason triggering a load of /dev/ttyS* (ie the
serial 8250 stuff) from within the module loading scripts. You'll need to
debug the user space and work out why the loop is happening then it
should be fairly easy to fix.

Alan
