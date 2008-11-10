Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYKJXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYKJXsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYKJXsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:48:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401AbYKJXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:48:41 -0500
Date: Mon, 10 Nov 2008 23:48:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
Message-ID: <20081110234843.0fba9f16@lxorguk.ukuu.org.uk>
In-Reply-To: <20081110143039.6f21fdc3.akpm@linux-foundation.org>
References: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081104174142.360a964a@lxorguk.ukuu.org.uk>
	<20081110143039.6f21fdc3.akpm@linux-foundation.org>
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

> That's a regression in current gcc, surely?

Oh and as a PS: Gcc is I believe right because if the loop is run zero
times then pos = NULL (ie n == NULL so the first BUG_ON fires)


Alan
