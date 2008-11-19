Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYKSQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYKSQVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKSQVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:21:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45925 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033AbYKSQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:21:02 -0500
Date: Wed, 19 Nov 2008 16:20:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, x86@vger.kernel.org, tytso@mit.edu,
       linux-ide@vger.kernel.org
Subject: Re: Oops/Warning report for the week of November 19th, 2008
Message-ID: <20081119162039.74661670@lxorguk.ukuu.org.uk>
In-Reply-To: <20081119080106.23943160@infradead.org>
References: <20081119080106.23943160@infradead.org>
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

> Rank 7: __atapi_pio_bytes (warning)
> 	Reported 108 times
> 	This is a new entry this week that started showing up
> 	This warning was last seen in version 2.6.27.5, and first seen in 2.6.27.4.
> 	More info: http://www.kerneloops.org/searchweek.php?search=__atapi_pio_bytes

Someone is feeding the driver an sg list which has an odd number of bytes
in an sg list entry which isnt the final one.

Now I don't offhand know if that is valid or not but if it occurs then
the libata code can't cope.

Alan
