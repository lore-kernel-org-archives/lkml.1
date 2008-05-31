Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYEaMut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYEaMut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 08:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYEaMul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 08:50:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49063 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbYEaMul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 08:50:41 -0400
Date: Sat, 31 May 2008 13:35:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
Subject: Re: [PATCH] kaweth: use request_firmware()
Message-ID: <20080531133547.10b5d7f6@core>
In-Reply-To: <7D3DC891-CC9A-4CBD-8DCF-E684A2FB36B2@holtmann.org>
References: <1211708969@pmac.infradead.org>
	<1212070841.26088.28.camel@shinybook.infradead.org>
	<200805301555.59327.oliver@neukum.org>
	<1212160598.8199.6.camel@shinybook.infradead.org>
	<FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org>
	<20080530164842.31b23848@core>
	<7D3DC891-CC9A-4CBD-8DCF-E684A2FB36B2@holtmann.org>
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

> I was not late to the party. I was the first one using  
> request_firmware() and always keeping an eye on drivers using it and  
> making sure using it correctly. However drivers sneaked in without  
> that I realized it. Mainly because I don't have that hardware and  
> reviewing every single driver obviously never happened.

Nothing in the documentation says that it can't have a heirarchical name,
so naturally lots of people did it. They didn't sneak in - they improved
on the interface and evolved it. They did it in a way that didn't upset
anything else (which is why you didn't notice).

No sneaking involved.

> I repeatedly said that no hierarchical namespace should be used (and  
> this was a couple of years ago) and now since some developers misuse  
> it, it makes it right. 

It means by consensus the developer community decided that a heirarchical
namespace was useful. And that is the party you've arrived late for.

Alan
