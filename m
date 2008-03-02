Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYCBTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYCBTRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYCBTRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:17:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51492 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbYCBTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:17:12 -0500
Date: Sun, 2 Mar 2008 19:05:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pawel Plociennik <paplociennik@gmail.com>
Cc: "Guillaume Chazarain" <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
Message-ID: <20080302190547.1c0e3742@core>
In-Reply-To: <200803021859.30473.paplociennik@gmail.com>
References: <200803011409.59526.paplociennik@gmail.com>
	<3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
	<200803021859.30473.paplociennik@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that procces which has pid 0 is a special procces because it

pid 1

> removes a *zombie* procceses so it is good to use a *dedicated*
> program for it such as a /sbin/init .
> /usr/sbin/chroot doesn't remove a *zombie* procceses :-(

It exec's the process so the resulting process is still pid 1
