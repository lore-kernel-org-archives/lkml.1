Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZA1Tpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZA1Tpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZA1Tpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:45:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57900 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbZA1Tpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:45:30 -0500
Date: Wed, 28 Jan 2009 19:45:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: speed up request_firmware()
Message-ID: <20090128194534.457d58cd@lxorguk.ukuu.org.uk>
In-Reply-To: <E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru>
References: <20090128180446.GB31107@ovro.caltech.edu>
	<E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru>
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

> Some drivers cache firmware in memory. Doubing the amount of needed memory 
> definitely would not be the best idea. Check drivers/net/wireless for 
> examples.

A lot of drivers could perfectly happily exist with a simple iterator
helper and being returned sg lists of pages. It seems that for big
firmwares at least there is a root cause which is deeper than how you
grow your vmalloc buffer.

Alan
