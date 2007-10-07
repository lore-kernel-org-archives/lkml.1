Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbXJGWJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbXJGWJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXJGWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:08:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46288 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752983AbXJGWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:08:56 -0400
Date: Sun, 7 Oct 2007 23:13:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bug #4580: hda: lost interrupt when resuming from S3 - Sony
 VGN-T1XP
Message-ID: <20071007231310.559dbd01@the-village.bc.nu>
In-Reply-To: <200710072217.07656.rjw@sisk.pl>
References: <200710072217.07656.rjw@sisk.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007 22:17:06 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> IDE/ATA wizzards are kindly requested to have a look at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=4580#c21
> 
> as I have no idea of what we can do about the "hard drive password vs suspend"
> problem, if anything.

libata supports the acpi interfaces but has them off by default. Turn
them on and it ought to just work assuming the BIOS does the right thing
and the BIOS knows the password.

