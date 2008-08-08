Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYHHQoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYHHQoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYHHQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:43:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33511 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760242AbYHHQnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:43:52 -0400
Date: Fri, 8 Aug 2008 17:26:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: worth separating serial from parallel ATA kernel options?
Message-ID: <20080808172629.232bed01@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
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

On Fri, 8 Aug 2008 12:32:23 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> 
>   asked from a position of appalling ignorance, but would it be more
> organized to be able to select serial ATA functionality separately
> from parallel ATA? 

The correct fix is to remove the (experimental) from the Parallel ATA
drivers Kconfig

For the rest of the menu the list is SATA first, then PATA (and PATA is
roughly alphabetic but both want a tidy)
