Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZBGAJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZBGAJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZBGAJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:09:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbZBGAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:09:16 -0500
Date: Sat, 7 Feb 2009 00:09:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com
Subject: Re: [PATCH] tty: fix bug - kernel can't be pinged through when
 bootargs console=null
Message-ID: <20090207000934.6805a35a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090206160555.b95e02bc.akpm@linux-foundation.org>
References: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
	<20090206160555.b95e02bc.akpm@linux-foundation.org>
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

> Did any earlier kernel versions handle this situation OK?
> 
> If so, we might need to be back-compatible with buggy userspace :(

Nothing to do with userspace. You can't call tty_driver_kref_get(NULL),
it's completely bogus.
