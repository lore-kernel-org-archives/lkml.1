Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXJCUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXJCUm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXJCUmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:42:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33176 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755344AbXJCUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:42:51 -0400
Date: Wed, 3 Oct 2007 21:40:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: casey@schaufler-ca.com
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory
 Access Control Kernel
Message-ID: <20071003214045.72b6b9e0@the-village.bc.nu>
In-Reply-To: <342112.80881.qm@web36601.mail.mud.yahoo.com>
References: <20071003191735.4d92c593@the-village.bc.nu>
	<342112.80881.qm@web36601.mail.mud.yahoo.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> An embedded system that does not have user logins but that does
> have applications that require separation, perhaps a moble communication
> device with application download capability, is just one example
> where the smack symlink implementation provides the required
> function without requiring application support.

I don't see what is such a problem here. For your mobile example you'd
give the application download side its own /tmp via mount.

Its actually better this is done in user space as its more flexible that
way and can be tuned arbitarily to meet interesting or bizarre real world
cases.

Alan
