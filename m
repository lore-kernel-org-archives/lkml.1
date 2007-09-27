Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXI0ONn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXI0ONn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXI0ONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:13:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48028 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755165AbXI0ON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:13:29 -0400
Date: Thu, 27 Sep 2007 15:19:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
 without options
Message-ID: <20070927151921.29b19abb@the-village.bc.nu>
In-Reply-To: <20070927070118.2bd4792e@laptopd505.fenrus.org>
References: <20070927142919.10b62f9b@the-village.bc.nu>
	<20070927070118.2bd4792e@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 07:01:18 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 27 Sep 2007 14:29:19 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > The early LFS work that Linux uses favours EFBIG in various places.
> > SuSv3 specifically uses EOVERFLOW for this as noted by Michael (Bug
> > 7253)
> isn't this an ABI change?

Its a change of a specific error return from the wrong error to the right
one, nothing more. Fixing the returned error gives us correct behaviour
according to the standards and other systems.

Alan
