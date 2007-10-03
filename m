Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbXJCSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbXJCSQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXJCSQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:16:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49911 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757231AbXJCSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:16:38 -0400
Date: Wed, 3 Oct 2007 19:17:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory
 Access Control Kernel
Message-ID: <20071003191735.4d92c593@the-village.bc.nu>
In-Reply-To: <20071003175237.GK8181@ftp.linux.org.uk>
References: <20071003051254.GH8181@ftp.linux.org.uk>
	<287091.73995.qm@web36604.mail.mud.yahoo.com>
	<20071003175237.GK8181@ftp.linux.org.uk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Absolute paths in that kind of thing are _wrong_.  You know where the things
> are on your fs.  You don't know if anything else will be visible, let alone
> whether it will be at the same place in all chroots or namespaces.  And no,
> you _can't_ make sure that fs is visible only in one place.  No fs can or
> has any business even trying.

What I don't understand here is why we need the hacks when we already
support sufficient mount magic to give each login session its own
private /tmp ?
