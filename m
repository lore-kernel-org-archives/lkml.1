Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYFPKvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYFPKvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYFPKu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:50:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56136 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbYFPKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:50:55 -0400
Date: Mon, 16 Jun 2008 11:33:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
Message-ID: <20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
In-Reply-To: <873andbst2.fsf@saeurebad.de>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik>
	<873andbst2.fsf@saeurebad.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The bug still exists, however, a bisect on another machine with the same
> userland leads to different commit
> (47f86834bbd4193139d61d659bebf9ab9d691e37 "redo locking of tty->pgrp"),
> so it is not all that clear and stable.

Now that would actually make a lot more sense as a root cause.
