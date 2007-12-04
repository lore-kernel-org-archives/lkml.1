Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbXLDQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbXLDQwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXLDQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:51:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38271 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbXLDQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:51:57 -0500
Date: Tue, 4 Dec 2007 16:47:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204164720.6e4dc2c4@the-village.bc.nu>
In-Reply-To: <20071204161811.GB15974@stusta.de>
References: <20071204114125.GA17310@torres.zugschlus.de>
	<20071204161811.GB15974@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No matter what you consider as being better, changing a 12 years old and 
> widely used userspace interface like /dev/urandom is simply not an 
> option.

Fixing it to be more efficient in its use of entropy and also fixing the
fact its not actually a good random number source would be worth looking
at however.
