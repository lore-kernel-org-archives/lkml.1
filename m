Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYHCMQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYHCMQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYHCMQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:16:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753572AbYHCMQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:16:34 -0400
Date: Sun, 3 Aug 2008 12:59:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: petkovbb@gmail.com
Cc: petkovbb@googlemail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080803125907.67676948@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803073756.GA8762@gollum.tnic>
References: <20080715053356.GA18628@gollum.tnic>
	<200808021902.12191.bzolnier@gmail.com>
	<20080802183253.GA2239@gollum.tnic>
	<200808022046.16990.bzolnier@gmail.com>
	<20080803073756.GA8762@gollum.tnic>
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

On Sun, 3 Aug 2008 09:37:56 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> Ok, here's a definitely better solution:

Please don't stuff large important pieces of code in header files where
they will be overlooked

NAK this.

I'm happy to have a shared library directory for ATA stuff, containing
useful C code, but hiding stuff in headers like that is just plain wrong.

