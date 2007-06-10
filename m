Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXFJPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXFJPQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXFJPQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:16:25 -0400
Received: from [81.2.110.250] ([81.2.110.250]:59375 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752060AbXFJPQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:16:24 -0400
Date: Sun, 10 Jun 2007 16:21:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610162134.078db9f0@the-village.bc.nu>
In-Reply-To: <5dr6okgvuq.fsf@Hurtta06k.keh.iki.fi>
References: <20070609014140.GC4095@ftp.linux.org.uk>
	<466A0BFB.3070908@redhat.com>
	<20070609151521.GD4095@ftp.linux.org.uk>
	<466AD4BA.80407@redhat.com>
	<20070609165454.GE4095@ftp.linux.org.uk>
	<466ADEAB.7080202@redhat.com>
	<20070609172429.GF4095@ftp.linux.org.uk>
	<2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
	<20070609200645.GG4095@ftp.linux.org.uk>
	<alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
	<20070610031922.GC21478@ftp.linux.org.uk>
	<alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
	<5dr6okgvuq.fsf@Hurtta06k.keh.iki.fi>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Real world example is nss_ldap / pam_ldap -- these needs open socket to 
> ldap server.  That socket is cached. And because they can not trust that 
> application does not have closed file description of them, they check it with 
> getpeername + getsockname  (at least it did when I looked code on
> some years ago.)   
> 
> ( opening socket again includes using starttls and  authentication  .. so it is 
>   quite some overhead )

And if the fd was closed because of a security transition in the
application hiding it and caching it from the application might then lead
to a security hole.

Alan
