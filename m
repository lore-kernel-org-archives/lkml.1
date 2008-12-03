Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYLCKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYLCKOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYLCKOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:14:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59172 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbYLCKOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:14:36 -0500
Date: Wed, 3 Dec 2008 10:13:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Subject: Re: [PATCH 1/1] ATA: piix, fix pointer deref on suspend
Message-ID: <20081203101342.5041f3fb@lxorguk.ukuu.org.uk>
In-Reply-To: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
References: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
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

On Wed,  3 Dec 2008 09:13:46 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> I've found this issue in the mmotm 2008-12-02-17-08.
> 
> --
> 
> Commit
> ata_piix: add borked Tecra M4 to broken suspend list
> introduced DMI variables checking, but they can be null, so that
> we possibly dereference null.
> 
> Check if they are null and avoid checks in that case.

Gak.. Add some kind of helper to the dmi code to do this and do the
comparison.
