Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZKHUGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZKHUGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:06:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZKHUGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:06:01 -0500
Received: from khc.piap.pl ([195.187.100.11]:55996 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbZKHUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:06:00 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: ata_sff_data_xfer* return value
References: <m37hu0bywp.fsf@intrepid.localdomain>
	<20091108200050.20d96a44@lxorguk.ukuu.org.uk>
Date: Sun, 08 Nov 2009 21:06:04 +0100
In-Reply-To: <20091108200050.20d96a44@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sun, 8 Nov 2009 20:00:50 +0000")
Message-ID: <m3y6mgaij7.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> It is correct. We return the bytes consumed as it may well not be the
> same as the total bytes requested. In practice we don't currently do a
> great deal with it even with ATAPI but it's useful for doing bug checks.

I see. Thanks.
-- 
Krzysztof Halasa
