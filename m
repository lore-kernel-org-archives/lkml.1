Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXE3Jaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXE3Jaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXE3Jat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:30:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37345 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbXE3Jas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:30:48 -0400
Date: Wed, 30 May 2007 10:35:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arkadiusz Mehlich <ris@elsat.net.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pata_amd hangs system
Message-ID: <20070530103550.4ddc5ba7@the-village.bc.nu>
In-Reply-To: <loom.20070530T002505-935@post.gmane.org>
References: <loom.20070530T002505-935@post.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 22:33:17 +0000 (UTC)
Arkadiusz Mehlich <ris@elsat.net.pl> wrote:

> Hi,
> Recently i switched from old ide interface to new libata (pata) interface.
> With old drivers all's be ok.
> 
> When i switch to new driver (pata_amd on MCP55) my burning software (k3b) totaly
> hangs system when i have DVD-R, DVD+R in my drive ... with CD-R, CD-ROM, DVD-ROM
> work fine.
> 
> System hungs on 'detecting media' stage.
> 
> There is workaround or patch to fix this problem ?
> Is not k3b problem !

Please file a bug in bugzilla.kernel.org, include kernel version, lspci
-vvxx, dmesg and as much info as you can get when it hangs (it may help
to try cdrecord on the command line here and see if that also hangs as if
you are not in X you'll get any kernel panic messages needed to debug it).

Also if you have time to roll your own kernel with all the kernel debug
options on (especially lock debugging) and do the same as the above that
may also produce interesting traces.

Alan
