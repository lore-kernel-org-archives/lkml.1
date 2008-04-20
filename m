Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYDTKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYDTKIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYDTKIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:08:39 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:53122 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822AbYDTKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:08:39 -0400
Date: Sun, 20 Apr 2008 10:41:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w6692: replace deprecated pci_find_device
Message-ID: <20080420104102.78b4d50b@the-village.bc.nu>
In-Reply-To: <480B151A.2040601@xs4all.nl>
References: <480B151A.2040601@xs4all.nl>
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

On Sun, 20 Apr 2008 12:04:10 +0200
Udo van den Heuvel <udovdh@xs4all.nl> wrote:

> Hello,
> 
> Found this is still necessary for 2.6.25 for the w6692 hisax isdn cards.
> Maybe someone has already prepared a patch?
> If not you could use this one.
> 
> 
> 1. replace deprecated pci_find_device
> 
> Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>

NAK. You can't simply replace it - you need to make correct use of
pci_dev_put as well.

Alan
