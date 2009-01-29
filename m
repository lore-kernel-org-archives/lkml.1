Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZA2Te2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZA2Te2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZA2TeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:34:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50292 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751552AbZA2TeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:34:20 -0500
Date: Thu, 29 Jan 2009 19:34:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: bmckinlay@perle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
Message-ID: <20090129193440.2c6efb65@lxorguk.ukuu.org.uk>
In-Reply-To: <OFD0116D1D.5061D2AB-ON8525754D.005C6317-8525754D.00661977@perle.com>
References: <20090128204705.7140d5fd@lxorguk.ukuu.org.uk>
	<OFD0116D1D.5061D2AB-ON8525754D.005C6317-8525754D.00661977@perle.com>
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

>   - any required documentation explaining how the driver works and 
> describing
>     the API for the master side of the PTY driver ?

The first most useful part would be understand what your pty driver does
and is required that is not in the base one. Just an idea of what extra
APIs it provides would be quite useful. If it is stuff like virtual modem
lines then that is stuff I want to see supported in the base kernel
anyway.

> As mentioned above the Linux kernel has supported "out of tree" PTY type 
> TTY 
> drivers all the way back to kernel 2.2.x and up to 2.6.27. To do this the 

By chance.. as to policies about kernel recompiles, that is between you
and the vendors. Maybe the vendors will add the symbols to their tree for
you ?

Equally look at the positives - if the facilities you need are in the
base kernel your customers won't run into arguments between yourselves
and the base kernel vendor over support.

Alan
