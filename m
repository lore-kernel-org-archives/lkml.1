Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYKNBTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYKNBTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYKNBSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:18:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42489 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753855AbYKNBSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:18:54 -0500
Date: Fri, 14 Nov 2008 01:18:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: [PATCH] New IDE/block driver for OCTEON SOC Compact Flash
 interface.
Message-ID: <20081114011851.1fa01a33@lxorguk.ukuu.org.uk>
In-Reply-To: <491CC0B6.8020400@ru.mvista.com>
References: <491C7F28.2070507@caviumnetworks.com>
	<491CC0B6.8020400@ru.mvista.com>
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

> OTOH, CF support via self-contained driver is certainly a waste of code 
> since IDE core and (libata) are here to drive the CF devices as well. 
> What we need is a "normal" IDE or libata (at your option) driver.

A libata driver would be nice and probably easiest to do as you don't
have to pretend to be close to old style taskfile IDE for a PC.

I am not convinced there is no case for a 'dumb' small CF driver, but if
so the chipset code and the core code need to be separated as the other
requests I see for this are different embedded boxes wanting to keep
codesize down.

Alan
