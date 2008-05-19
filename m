Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbYESPeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbYESPeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYESPd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:33:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58399 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805AbYESPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:33:57 -0400
Date: Mon, 19 May 2008 16:22:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080519162206.18949d0b@core>
In-Reply-To: <48319CC2.705@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
	<20080519123111.97C0C1B41FF@basil.firstfloor.org>
	<20080519140339.GB24267@infradead.org>
	<483191F9.3010706@firstfloor.org>
	<20080519161224.030b82c3@core>
	<48319CC2.705@firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The good news is that none of them I looked at actually needed BKL
> (or perhaps I just missed it)

Far better to send an initial patch that simply adds all the lock/unlocks
then remove them later than worry about it immediately - that makes it
easier to verify changes and to do testing

Alan
