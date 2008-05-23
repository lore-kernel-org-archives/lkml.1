Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYEWToi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYEWToi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbYEWToc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:44:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46830 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755522AbYEWTob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:44:31 -0400
Date: Fri, 23 May 2008 20:31:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080523203113.4dc38901@core>
In-Reply-To: <4836EE8C.1010200@linux.intel.com>
References: <4836EE8C.1010200@linux.intel.com>
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

> Rank 4: bad_io_access
> 	Reported 111 times (153 total reports)
> 	Bug with pata_isapnp causing another ata driver to go SPLAT

Bug in libata-sff and one that really proved the value of the oops work
you did. Nobody ever reported it in bugzilla in a way that made it
apparent what was up (I guess as it was an install crash) and probably
99% of users hitting it wouldn't even have thought their soundcard had an
unused, and possible unwired, IDE port.
