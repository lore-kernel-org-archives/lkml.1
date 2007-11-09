Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbXKIMEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbXKIMEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXKIMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:04:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35440 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751578AbXKIMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:04:32 -0500
Date: Fri, 9 Nov 2007 12:04:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Riki Oktarianto <rkoktarianto@gmail.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109120425.543971bf@the-village.bc.nu>
In-Reply-To: <20071109034622.GB25581@havoc.gtf.org>
References: <20071109020235.GA2031@ceren>
	<20071109023129.GA25581@havoc.gtf.org>
	<4733D421.7000505@rtr.ca>
	<20071109034622.GB25581@havoc.gtf.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 22:46:22 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
> > And I might even privately patch my own kernels to map the ACHI BAR
> > in the cases where the BIOS didn't...
> 
> The inability to do this in the general case is the main reason why
> AHCI was not unconditionally enabled, even in IDE mode, when it was
> originally added...  :/

We've done it all the time for various devices without problems (eg S3
video cards). I'd like to see it go in - although perhaps attached to a
force_ahci boot param initially
