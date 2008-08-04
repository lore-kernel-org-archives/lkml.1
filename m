Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYHDO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYHDO3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYHDO3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:29:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55886 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754257AbYHDO3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:29:11 -0400
Date: Mon, 4 Aug 2008 15:11:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Keith Packard <keithp@keithp.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: files/process scaling problem? (was: [PATCH] Export
 shmem_file_setup and shmem_getpage for DRM-GEM)
Message-ID: <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804065101.6f70725a@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<18581.43362.460694.60862@stoffel.org>
	<1217785943.23437.330.camel@koto.keithp.com>
	<200808040135.32563.ioe-lkml@rameria.de>
	<1217809152.23437.401.camel@koto.keithp.com>
	<20080804091930.164f31c3@lxorguk.ukuu.org.uk>
	<20080804065101.6f70725a@infradead.org>
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

On Mon, 4 Aug 2008 06:51:01 -0700
> the hard part is that DRI is a library that gets linked into existing
> applications... which already are using select ;-(
> 
> Fixing X is one thing and not impossible.. fixing all existing games in
> the field is quite another

X libraries provide the event loop so that isn't really as complex as it
seems. Shuffling the handles around for the benefit of the odd legacy app
isn't something I'd disagree with but DRI and X in the general case can
determine the event loop system used by the application.

Alan
