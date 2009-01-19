Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbZASLRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbZASLRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZASLRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:17:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37977 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754861AbZASLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:17:38 -0500
Date: Mon, 19 Jan 2009 11:17:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: sam@ravnborg.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: install to a single directory
Message-ID: <20090119111745.404e2794@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
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

On Sun, 18 Jan 2009 22:17:16 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

> Hi,
> 
> 
> 
> This proposed change will collect all kernel modules in the
> single directory, e.g. /lib/modules/2.6.29-rc2/kernel/, without
> any further directory structure. About 475 inodes (with
> almost-allmodconfig) less are used, which should result
> in faster directory traversal (less seeks).

What do your benchmark numbers look like ?
