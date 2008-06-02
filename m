Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbYFBQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbYFBQDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYFBQDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:03:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44554 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627AbYFBQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:03:44 -0400
Date: Mon, 2 Jun 2008 16:48:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602164840.0dc9cb96@core>
In-Reply-To: <20080602145603.GG26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com>
	<20080602075113.60d0fdf8@core>
	<20080602092551.GC26854@enneenne.com>
	<20080602150257.54692f35@core>
	<20080602145603.GG26854@enneenne.com>
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

> I prefere avoid the if clause for getnstimeofday() since each
> instruction delay may decrease time precision, so:

Why should everyone else pay the cost of the getnstimeofday they don't
need ?

The single conditional check at the start won't make the slightest
material difference to your accuracy.

Alan
