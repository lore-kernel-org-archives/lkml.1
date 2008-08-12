Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYHLOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYHLOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHLOi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:38:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbYHLOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:38:28 -0400
Date: Tue, 12 Aug 2008 15:21:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080812152100.0123a2e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812070222.3dc9efcb@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153641.706726ec@infradead.org>
	<20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
	<20080812043603.3d8471d4@infradead.org>
	<20080812130027.2c4643a9@lxorguk.ukuu.org.uk>
	<20080812070222.3dc9efcb@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and can add the option for this case. It's the "push policy out of the
> kernel" thing.. while the kernel probably can't know this (and you're
> right, the DMI patch is thus the wrong thing to do).. the admin can.

libata lets you set the nth controller to various things (40wire etc) so
I suspect the right thing to extent is the existing libata option code
that Tejun wrote to include 'skip' if it doesn't already.

If that gets done cc me and I'll then go audit the drivers to see who
apart from it821x knows port 0 is always probed
