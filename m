Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYFPSkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYFPSkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYFPSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:40:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33729 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYFPSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:40:31 -0400
Date: Mon, 16 Jun 2008 19:22:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
Message-ID: <20080616192255.312b6be5@lxorguk.ukuu.org.uk>
In-Reply-To: <87ve099yyt.fsf@saeurebad.de>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik>
	<873andbst2.fsf@saeurebad.de>
	<20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
	<20080616124602.54910afd@lxorguk.ukuu.org.uk>
	<87ve099yyt.fsf@saeurebad.de>
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

> tty->session =
> tty->pgrp =
> spin_unlock()
> 
> That does not fix it.

Thanks. That rules out the one case I could see that might have pointed
to a potential bug.

Alan
