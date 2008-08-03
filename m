Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYHCN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYHCN5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYHCN5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:57:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59444 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755124AbYHCN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:57:43 -0400
Date: Sun, 3 Aug 2008 14:39:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: petkovbb@gmail.com, petkovbb@googlemail.com, alan@redhat.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080803143939.37a74bf5@lxorguk.ukuu.org.uk>
In-Reply-To: <200808031537.41224.bzolnier@gmail.com>
References: <20080715053356.GA18628@gollum.tnic>
	<20080803073756.GA8762@gollum.tnic>
	<20080803125907.67676948@lxorguk.ukuu.org.uk>
	<200808031537.41224.bzolnier@gmail.com>
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

> The code in question is 65 LOC total (43 LOC without counting comments)
> so having a shared library just for it sounds like an overkill and we may

People expect code in C files, so in headers it gets missed as well as
dumped in a directory with no correlation between file name and subsystem.

> just copy that one function from pata_legacy to ide_generic instead.

If you are going to  #include two copies you might as well just copy it.

Alan
