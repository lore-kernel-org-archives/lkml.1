Return-Path: <linux-kernel-owner+w=401wt.eu-S1764628AbYDXP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764628AbYDXP1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYDXPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:16:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44954 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760342AbYDXPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:16:22 -0400
Date: Thu, 24 Apr 2008 15:48:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan McGee <dpmcgee@gmail.com>
Cc: htejun@gmail.com, jeff@garzik.org, linux-kernel@vger.kernel.org,
       Dan McGee <dpmcgee@gmail.com>
Subject: Re: [PATCH] ata_piix: add Asus Eee 701 controller to short cable
 list
Message-ID: <20080424154811.696fcb05@the-village.bc.nu>
In-Reply-To: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
References: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 22:03:27 -0500
Dan McGee <dpmcgee@gmail.com> wrote:

> The drive is directly soldered to the controller, so there is no cable at
> all. Remove the 40-wire assumption so the drive can operate at max speed.
> 
> Before patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 5.29612 s, 25.3 MB/s
> 
> After patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 3.94955 s, 34.0 MB/s
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>
