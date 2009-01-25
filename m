Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZAYUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZAYUq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZAYUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:46:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46072 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751301AbZAYUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:46:16 -0500
Date: Sun, 25 Jan 2009 20:46:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
Message-ID: <20090125204603.2ccb5169@lxorguk.ukuu.org.uk>
In-Reply-To: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
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

On Mon, 26 Jan 2009 02:09:56 +0530
Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello all,
> 
> I added extra IDE drive I get similar messages like below so I replace
> it another drive but I am still getting similar error messages on
> 2.6.29-rc2-tip:
> 
> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
> hdb: status error: error=0x40 <3>{ UncorrectableError },
> LBAsect=208845, sector=0

Uncorrectable Error is an error from the drive, not the kernel. Looks
like you have bad sectors on that drive.

Alan
